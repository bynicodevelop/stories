import 'package:formz/formz.dart';

enum PasswordInputState { empty, invalid }

class Password extends FormzInput<String, PasswordInputState> {
  const Password.pure([String value = '']) : super.pure(value);

  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordInputState? validator(String? value) {
    if (value!.isEmpty == true) {
      return PasswordInputState.empty;
    }

    if (value.length < 6) {
      return PasswordInputState.invalid;
    }

    return null;
  }
}
