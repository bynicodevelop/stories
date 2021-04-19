part of 'form_auth_bloc.dart';

class FormAuthState extends Equatable {
  final Email email;
  final Password password;
  final FormzStatus status;

  const FormAuthState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
  });

  FormAuthState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
  }) {
    return FormAuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, status];
}
