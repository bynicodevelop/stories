part of 'authentication_bloc.dart';

enum AuthenticationErrorType {
  emailAlreadyExists,
  passwordTooShort,
  badCredentials,
}

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSubmittingState extends AuthenticationState {}

class AuthenticationSubmittedState extends AuthenticationState {}

class AuthenticationErrorState extends AuthenticationState {
  final AuthenticationErrorType authenticationErrorType;

  AuthenticationErrorState(this.authenticationErrorType);
}

class AuthenticatedAnonymouslyState extends AuthenticationState {}

class AuthenticatedState extends AuthenticationState {}

class UnauthenticatedState extends AuthenticationState {}
