import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/story_model.dart';
import 'package:kdofavoris/repositories/profile_repository.dart';
import 'package:mockito/mockito.dart';

class ProfileRepositoryMock extends Mock implements ProfileRepository {
  Future<List<ProfileModel>> get profiles => super.noSuchMethod(
        Invocation.getter(#profiles),
        returnValue: Future.value(<ProfileModel>[]),
      );

  Future<ProfileModel?> profileBySlug(String slug) =>
      super.noSuchMethod(Invocation.method(#profileBySlug, [slug]),
          returnValue: Future.value(null));

  Future<bool> likeStory(StoryModel storyModel) async => super.noSuchMethod(
        Invocation.method(#likeStory, [storyModel]),
        returnValue: Future.value(true),
      );
}
