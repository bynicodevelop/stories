part of 'form_auth_bloc.dart';

abstract class FormAuthEvent extends Equatable {
  const FormAuthEvent();

  @override
  List<Object> get props => [];
}

class FormAuthEmailUnfocused extends FormAuthEvent {}

class FormAuthEmailChanged extends FormAuthEvent {
  final String email;

  const FormAuthEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class FormAuthPasswordUnfocused extends FormAuthEvent {}

class FormAuthPasswordChanged extends FormAuthEvent {
  final String password;

  const FormAuthPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class FormAuthSubmitted extends FormAuthEvent {}
