import 'package:kdofavoris/models/user_model.dart';
import 'package:kdofavoris/repositories/auth_repository.dart';
import 'package:mockito/mockito.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {
  @override
  Future<bool> get isAuthenticated async => super.noSuchMethod(
        Invocation.getter(#isAuthenticated),
        returnValue: Future.value(false),
      );

  @override
  Future<UserModel?> get user async => super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: null,
      );

  @override
  Future<void> register(String email, String password) async =>
      super.noSuchMethod(Invocation.method(#register, [email, password]));

  @override
  Future<void> connection(String email, String password) async =>
      super.noSuchMethod(Invocation.method(#connection, [email, password]));

  @override
  Future<void> anonymousConnection() async =>
      super.noSuchMethod(Invocation.method(#anonymousConnection, []));

  @override
  Future<void> logout() async =>
      super.noSuchMethod(Invocation.method(#logout, []));
}
