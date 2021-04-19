import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/user_model.dart';
import 'package:kdofavoris/repositories/user_repository.dart';
import 'package:mockito/mockito.dart';

class UserRepositoryMock extends Mock implements UserRepository {
  @override
  Future<UserModel> get user async => super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: UserModel(
            uid: "uid",
            displayName: "displayName",
            avatar: "avatar",
            slug: "slug"),
      );

  @override
  Future<List<ProfileModel>> get followingrs async =>
      super.noSuchMethod(Invocation.getter(#followings),
          returnValue: <ProfileModel>[]);

  @override
  Future<List<ProfileModel>> get followers async =>
      super.noSuchMethod(Invocation.getter(#followers),
          returnValue: <ProfileModel>[]);
}
