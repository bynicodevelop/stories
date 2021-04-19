import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:kdofavoris/forms/validators/email.dart';
import 'package:kdofavoris/forms/validators/password.dart';

part 'form_auth_event.dart';
part 'form_auth_state.dart';

class FormAuthBloc extends Bloc<FormAuthEvent, FormAuthState> {
  FormAuthBloc() : super(FormAuthState());

  @override
  Stream<FormAuthState> mapEventToState(
    FormAuthEvent event,
  ) async* {
    if (event is FormAuthEmailUnfocused) {
      final email = Email.dirty(state.email.value);

      yield state.copyWith(
        email: email,
        status: Formz.validate([email, state.password]),
      );
    } else if (event is FormAuthEmailChanged) {
      final email = Email.dirty(event.email);

      yield state.copyWith(
        email: email.valid ? email : Email.pure(event.email),
        status: Formz.validate([email, state.password]),
      );
    } else if (event is FormAuthPasswordUnfocused) {
      final password = Password.dirty(state.password.value);

      yield state.copyWith(
        password: password,
        status: Formz.validate([password, state.email]),
      );
    } else if (event is FormAuthPasswordChanged) {
      final password = Password.dirty(event.password);

      yield state.copyWith(
        password: password.valid ? password : Password.pure(event.password),
        status: Formz.validate([password, state.email]),
      );
    } else if (event is FormAuthSubmitted) {
      final email = Email.dirty(state.email.value);
      final password = Password.dirty(state.password.value);

      yield state.copyWith(
        email: email,
        password: password,
        status: Formz.validate([email, password]),
      );
    }
  }
}
