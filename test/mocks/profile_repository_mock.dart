import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/repositories/profile_repository.dart';
import 'package:mockito/mockito.dart';

class ProfileRepositoryMock extends Mock implements ProfileRepository {
  Future<List<ProfileModel>> get profiles => super.noSuchMethod(
        Invocation.getter(#profiles),
        returnValue: Future.value(<ProfileModel>[]),
      );
}
