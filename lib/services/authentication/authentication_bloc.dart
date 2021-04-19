import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kdofavoris/exceptions/bad_credentials_exception.dart';
import 'package:kdofavoris/exceptions/email_altrady_exists_exception.dart';
import 'package:kdofavoris/exceptions/password_too_short_exception.dart';
import 'package:kdofavoris/models/user_model.dart';
import 'package:kdofavoris/repositories/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;

  AuthenticationBloc(this._authRepository) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationInializeEvent) {
      bool isAuthenticated = await _authRepository.isAuthenticated;

      if (isAuthenticated) {
        final UserModel userModel = (await _authRepository.user)!;

        if (userModel.isAnonymous) {
          yield AuthenticatedAnonymouslyState();
        } else {
          yield AuthenticatedState();
        }

        return;
      }

      yield UnauthenticatedState();
    } else if (event is AuthenticationRegisterEvent) {
      yield AuthenticationSubmittingState();

      try {
        await _authRepository.register(
          event.email,
          event.password,
        );

        yield AuthenticationSubmittedState();

        yield AuthenticatedState();
      } on EmailAlreadyExistsException {
        yield AuthenticationErrorState(
          AuthenticationErrorType.emailAlreadyExists,
        );
      } on PasswordTooShortException {
        yield AuthenticationErrorState(
          AuthenticationErrorType.passwordTooShort,
        );
      }
    } else if (event is AuthenticationConnectionEvent) {
      yield AuthenticationSubmittingState();

      try {
        await _authRepository.connection(
          event.email,
          event.password,
        );

        yield AuthenticationSubmittedState();
        yield AuthenticatedState();
      } on BadCredentialsException {
        yield AuthenticationErrorState(AuthenticationErrorType.badCredentials);
      }
    } else if (event is AuthenticationAnonymousConnectionEvent) {
      yield AuthenticationSubmittingState();

      await _authRepository.anonymousConnection();

      yield AuthenticatedAnonymouslyState();
    } else if (event is AuthenticationLogoutEvent) {
      await _authRepository.logout();

      yield UnauthenticatedState();
    }
  }
}
