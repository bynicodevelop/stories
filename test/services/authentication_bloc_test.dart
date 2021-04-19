import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdofavoris/exceptions/bad_credentials_exception.dart';
import 'package:kdofavoris/exceptions/email_altrady_exists_exception.dart';
import 'package:kdofavoris/exceptions/password_too_short_exception.dart';
import 'package:kdofavoris/models/user_model.dart';
import 'package:kdofavoris/services/authentication/authentication_bloc.dart';
import 'package:mockito/mockito.dart';

import '../mocks/auth_repository_mock.dart';

main() {
  late AuthRepositoryMock authRepositoryMock;

  setUp(() {
    authRepositoryMock = AuthRepositoryMock();
  });

  group("Registration", () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      "Doit permettre l'enregistrement d'un utilisateur avec success",
      build: () {
        when(authRepositoryMock.register('john.doe@domain.tld', '123456789'))
            .thenAnswer((realInvocation) => Future.value());

        return AuthenticationBloc(authRepositoryMock);
      },
      act: (bloc) => bloc.add(AuthenticationRegisterEvent(
        email: 'john.doe@domain.tld',
        password: '123456789',
      )),
      expect: () => [
        AuthenticationSubmittingState(),
        AuthenticationSubmittedState(),
        AuthenticatedState(),
      ],
    );
    blocTest<AuthenticationBloc, AuthenticationState>(
      "Doit retourner une erreur si l'email existe déjà",
      build: () {
        when(authRepositoryMock.register('john.doe@domain.tld', '123456789'))
            .thenThrow(EmailAlreadyExistsException());

        return AuthenticationBloc(authRepositoryMock);
      },
      act: (bloc) => bloc.add(AuthenticationRegisterEvent(
        email: 'john.doe@domain.tld',
        password: '123456789',
      )),
      expect: () => [
        AuthenticationSubmittingState(),
        AuthenticationErrorState(AuthenticationErrorType.emailAlreadyExists),
      ],
      verify: (bloc) {
        expect((bloc.state as AuthenticationErrorState).authenticationErrorType,
            AuthenticationErrorType.emailAlreadyExists);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Doit retourner une erreur si le mot de passe est trop cours",
      build: () {
        when(authRepositoryMock.register('john.doe@domain.tld', '1234'))
            .thenThrow(PasswordTooShortException());

        return AuthenticationBloc(authRepositoryMock);
      },
      act: (bloc) => bloc.add(AuthenticationRegisterEvent(
        email: 'john.doe@domain.tld',
        password: '1234',
      )),
      expect: () => [
        AuthenticationSubmittingState(),
        AuthenticationErrorState(AuthenticationErrorType.passwordTooShort),
      ],
      verify: (bloc) {
        expect((bloc.state as AuthenticationErrorState).authenticationErrorType,
            AuthenticationErrorType.passwordTooShort);
      },
    );
  });

  group("Authentication", () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      "Doit permettre l'authentication d'un utilisateur avec succes",
      build: () {
        when(authRepositoryMock.connection('john.doe@domain.tld', '123456789'))
            .thenAnswer((realInvocation) => Future.value());

        return AuthenticationBloc(authRepositoryMock);
      },
      act: (bloc) => bloc.add(
        AuthenticationConnectionEvent(
          email: 'john.doe@domain.tld',
          password: '123456789',
        ),
      ),
      expect: () => [
        AuthenticationSubmittingState(),
        AuthenticationSubmittedState(),
        AuthenticatedState(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Doit retourne une erreur si l'email ou le mot de passe n'est pas correct",
      build: () {
        when(authRepositoryMock.connection('john.doe@domain.tld', '123456789'))
            .thenThrow(BadCredentialsException());

        return AuthenticationBloc(authRepositoryMock);
      },
      act: (bloc) => bloc.add(
        AuthenticationConnectionEvent(
          email: 'john.doe@domain.tld',
          password: '123456789',
        ),
      ),
      expect: () => [
        AuthenticationSubmittingState(),
        AuthenticationErrorState(AuthenticationErrorType.badCredentials),
      ],
      verify: (bloc) {
        expect((bloc.state as AuthenticationErrorState).authenticationErrorType,
            AuthenticationErrorType.badCredentials);
      },
    );
  });

  group("Anonymous Authentication", () {
    blocTest<AuthenticationBloc, AuthenticationState>(
        "Doit permettre une connection automatique de l'utilisateur",
        build: () {
          when(authRepositoryMock.anonymousConnection())
              .thenAnswer((_) => Future.value());

          return AuthenticationBloc(authRepositoryMock);
        },
        act: (bloc) => bloc.add(AuthenticationAnonymousConnectionEvent()),
        expect: () => [
              AuthenticationSubmittingState(),
              AuthenticatedAnonymouslyState(),
            ],
        verify: (bloc) {
          verify(authRepositoryMock.anonymousConnection());
        });
  });

  group("Logout", () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      "Doit permettre la déconnexion d'un utilisateur",
      build: () => AuthenticationBloc(authRepositoryMock),
      act: (bloc) => bloc.add(AuthenticationLogoutEvent()),
      expect: () => [
        UnauthenticatedState(),
      ],
      verify: (bloc) => verify(authRepositoryMock.logout()),
    );
  });

  group("Initialize", () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      "Doit vérifier que l'utilisateur est  connecté",
      build: () {
        when(authRepositoryMock.isAuthenticated)
            .thenAnswer((_) => Future.value(true));

        when(authRepositoryMock.user).thenAnswer(
          (_) => Future.value(
            UserModel(
              uid: "123456789",
              isAnonymous: false,
              displayName: "",
              avatar: "",
              slug: "",
            ),
          ),
        );

        return AuthenticationBloc(authRepositoryMock);
      },
      act: (bloc) => bloc.add(AuthenticationInializeEvent()),
      expect: () => [
        AuthenticatedState(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Doit vérifier que l'utilisateur est  connecté (anonyme)",
      build: () {
        when(authRepositoryMock.isAuthenticated)
            .thenAnswer((_) => Future.value(true));

        when(authRepositoryMock.user).thenAnswer(
          (_) => Future.value(
            UserModel(
              uid: "123456789",
              isAnonymous: true,
              displayName: "",
              avatar: "",
              slug: "",
            ),
          ),
        );

        return AuthenticationBloc(authRepositoryMock);
      },
      act: (bloc) => bloc.add(AuthenticationInializeEvent()),
      expect: () => [
        AuthenticatedAnonymouslyState(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Doit vérifier que l'utilisateur est déconnecté",
      build: () {
        when(authRepositoryMock.isAuthenticated)
            .thenAnswer((_) => Future.value(false));

        return AuthenticationBloc(authRepositoryMock);
      },
      act: (bloc) => bloc.add(AuthenticationInializeEvent()),
      expect: () => [
        UnauthenticatedState(),
      ],
    );
  });
}
