import 'package:flutter_test/flutter_test.dart';
import 'package:kdofavoris/forms/validators/email.dart';

main() {
  group("Email Model", () {
    test("Doit retourner une error si l'email n'est pas valide", () async {
      // ARRANGE
      Email slug = Email.dirty('john doe');

      // ACT
      bool res = slug.valid;

      // ASSERT
      expect(res, false);
    });

    test("Doit retourner un succes", () async {
      // ARRANGE
      Email slug = Email.dirty('john.doe@domain.tld');

      // ACT
      bool res = slug.valid;

      // ASSERT
      expect(res, true);
    });
  });
}
