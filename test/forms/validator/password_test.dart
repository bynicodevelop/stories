import 'package:flutter_test/flutter_test.dart';
import 'package:kdofavoris/forms/validators/password.dart';

main() {
  test("Utilisation nominal de la fonction", () async {
    // ARRANGE
    Password password = Password.dirty('123456');

    // ACT
    bool res = password.valid;

    // ASSERT
    expect(res, true);
    expect(password.validator('123456'), null);
  });

  test("Retourne une erreur si le mot de passe contient moins de 6 caractère",
      () async {
    // ARRANGE
    Password password = Password.dirty('12345');

    // ACT
    bool res = password.valid;

    // ASSERT
    expect(res, false);
    expect(password.validator('12345'), PasswordInputState.invalid);
  });
}
