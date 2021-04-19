import 'package:formz/formz.dart';

enum EmailInputState { empty, invalid }

class Email extends FormzInput<String, EmailInputState> {
  const Email.pure([String value = '']) : super.pure(value);

  const Email.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailInputState? validator(String? value) {
    if (value!.isEmpty == true) {
      return EmailInputState.empty;
    }

    if (!_emailRegExp.hasMatch(value)) {
      return EmailInputState.invalid;
    }

    return null;
  }
}
