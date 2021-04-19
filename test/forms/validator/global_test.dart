import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:kdofavoris/forms/validators/email.dart';
import 'package:kdofavoris/forms/validators/password.dart';

main() {
  test("Doit retourner une erreur quand la valeur est vide", () async {
    // ARRANGE
    List<FormzInput> inputs = [
      Email.dirty(),
      Password.dirty(),
    ];

    inputs.forEach((input) {
      // ACT
      bool res = input.valid;

      // ASSERT
      expect(res, false);
    });
  });
}
