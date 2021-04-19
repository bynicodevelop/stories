import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:kdofavoris/forms/types/auth/form_auth_bloc.dart';
import 'package:kdofavoris/forms/validators/email.dart';
import 'package:kdofavoris/forms/validators/password.dart';

main() {
  group("Email", () {
    blocTest<FormAuthBloc, FormAuthState>(
      "Doit retourner un état d'email invalide sans email",
      build: () => FormAuthBloc(),
      act: (bloc) => bloc.add(FormAuthEmailUnfocused()),
      expect: () => [
        FormAuthState(
          email: Email.dirty(),
          status: FormzStatus.invalid,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.email.valid, false);
      },
    );

    blocTest<FormAuthBloc, FormAuthState>(
      "Doit retourner un état d'email invalide avec un mauvais email",
      build: () => FormAuthBloc(),
      act: (bloc) => bloc.add(FormAuthEmailChanged('john.doe')),
      expect: () => [
        FormAuthState(
          email: Email.pure('john.doe'),
          status: FormzStatus.invalid,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.email.valid, false);
      },
    );

    blocTest<FormAuthBloc, FormAuthState>(
      "Doit retourner un état d'email valide",
      build: () => FormAuthBloc(),
      act: (bloc) => bloc.add(FormAuthEmailChanged('john.doe@domain.tld')),
      expect: () => [
        FormAuthState(
          email: Email.dirty('john.doe@domain.tld'),
          status: FormzStatus.invalid,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.email.valid, true);
      },
    );
  });

  group("Password", () {
    blocTest<FormAuthBloc, FormAuthState>(
      "Doit retourner un état de mot de passe invalide sans email",
      build: () => FormAuthBloc(),
      act: (bloc) => bloc.add(FormAuthPasswordUnfocused()),
      expect: () => [
        FormAuthState(
          password: Password.dirty(),
          status: FormzStatus.invalid,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.password.valid, false);
      },
    );

    blocTest<FormAuthBloc, FormAuthState>(
      "Doit retourner un état de mot de passe invalide avec un mauvais email",
      build: () => FormAuthBloc(),
      act: (bloc) => bloc.add(FormAuthPasswordChanged('123')),
      expect: () => [
        FormAuthState(
          password: Password.pure('123'),
          status: FormzStatus.invalid,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.password.valid, false);
      },
    );

    blocTest<FormAuthBloc, FormAuthState>(
      "Doit retourner un état de mot de passe valide",
      build: () => FormAuthBloc(),
      act: (bloc) => bloc.add(FormAuthPasswordChanged('1234567')),
      expect: () => [
        FormAuthState(
          password: Password.dirty('1234567'),
          status: FormzStatus.invalid,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.password.valid, true);
      },
    );
  });

  group("Form submitted", () {
    blocTest<FormAuthBloc, FormAuthState>(
      "Doit retourner un état de formulaire invalide (mauvais email)",
      build: () => FormAuthBloc(),
      act: (bloc) => [
        bloc.add(FormAuthPasswordChanged('123456')),
        bloc.add(FormAuthSubmitted()),
      ],
      expect: () => [
        FormAuthState(
          password: Password.dirty('123456'),
          status: FormzStatus.invalid,
        ),
        FormAuthState(
          email: Email.dirty(),
          password: Password.dirty('123456'),
          status: FormzStatus.invalid,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.status.isValid, false);
      },
    );

    blocTest<FormAuthBloc, FormAuthState>(
      "Doit retourner un état de formulaire invalide (mauvais mot de passe)",
      build: () => FormAuthBloc(),
      act: (bloc) => [
        bloc.add(FormAuthEmailChanged('john.doe@domain.tld')),
        bloc.add(FormAuthSubmitted()),
      ],
      expect: () => [
        FormAuthState(
          email: Email.dirty('john.doe@domain.tld'),
          status: FormzStatus.invalid,
        ),
        FormAuthState(
          email: Email.dirty('john.doe@domain.tld'),
          password: Password.dirty(),
          status: FormzStatus.invalid,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.status.isValid, false);
      },
    );

    blocTest<FormAuthBloc, FormAuthState>(
      "Doit retourner un état de formulaire valide",
      build: () {
        FormAuthBloc formAuthBloc = FormAuthBloc();

        formAuthBloc.emit(FormAuthState(
          email: Email.pure('john.doe@domain.tld'),
          password: Password.pure('123456'),
          status: FormzStatus.invalid,
        ));

        return formAuthBloc;
      },
      act: (bloc) => bloc.add(FormAuthSubmitted()),
      expect: () => [
        FormAuthState(
          email: Email.dirty('john.doe@domain.tld'),
          password: Password.dirty('123456'),
          status: FormzStatus.valid,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.status.isValid, true);
      },
    );
  });
}
