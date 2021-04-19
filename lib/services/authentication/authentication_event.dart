part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationInializeEvent extends AuthenticationEvent {}

class AuthenticationRegisterEvent extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticationRegisterEvent({
    required this.email,
    required this.password,
  });
}

class AuthenticationConnectionEvent extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticationConnectionEvent({
    required this.email,
    required this.password,
  });
}

class AuthenticationAnonymousConnectionEvent extends AuthenticationEvent {}

class AuthenticationLogoutEvent extends AuthenticationEvent {}
