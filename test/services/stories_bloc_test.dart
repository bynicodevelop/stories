import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/story_model.dart';
import 'package:kdofavoris/services/stories/stories_bloc.dart';
import 'package:mockito/mockito.dart';

import '../mocks/profile_repository_mock.dart';

main() {
  late ProfileRepositoryMock _profileRepositoryMock;

  final ProfileModel _profileModel = ProfileModel(
      slug: "slug",
      displayName: "displayName",
      avatar: "avatar",
      stories: [
        StoryModel(
          uid: "uid",
          storyPath: "storyPath",
        ),
      ]);

  final StoryModel _storyModel = StoryModel(
    uid: "123456789",
    storyPath: "path",
  );

  setUp(() {
    _profileRepositoryMock = ProfileRepositoryMock();
  });

  group("Chargement des stories", () {
    blocTest<StoriesBloc, StoriesState>(
      "Doit permettre de charger la liste des stories en fonction du profil selectionné",
      build: () {
        when(_profileRepositoryMock.profileBySlug("johndoe"))
            .thenAnswer((realInvocation) => Future.value(_profileModel));

        return StoriesBloc(_profileRepositoryMock);
      },
      act: (bloc) => bloc.add(LoadStoriesEvent("johndoe")),
      expect: () => [
        StoriesLoadingState(),
        StoriesLoadedState(
          profileModel: _profileModel,
        ),
      ],
    );

    blocTest<StoriesBloc, StoriesState>(
      "Doit retourner une erreur si le profile n'est pas trouvé",
      build: () {
        when(_profileRepositoryMock.profileBySlug("johndoe"))
            .thenAnswer((realInvocation) => Future.value(null));

        return StoriesBloc(_profileRepositoryMock);
      },
      act: (bloc) => bloc.add(LoadStoriesEvent("johndoe")),
      expect: () => [
        StoriesLoadingState(),
        StoriesErrorState(StoriesErrorStatus.noFound),
      ],
    );
  });

  group("Like de story", () {
    blocTest<StoriesBloc, StoriesState>(
      "Doit permettre de liker une story",
      build: () {
        when(_profileRepositoryMock.likeStory(_profileModel.stories.first))
            .thenAnswer((realInvocation) => Future.value(true));

        StoriesBloc storiesBloc = StoriesBloc(_profileRepositoryMock);

        storiesBloc.emit(StoriesLoadedState(
          profileModel: _profileModel,
        ));

        return storiesBloc;
      },
      act: (bloc) => bloc.add(LikeStoriesEvent(_profileModel.stories.first)),
      expect: () => [
        StoriesLikeInProgressState(_profileModel),
        StoriesLikedState(profileModel: _profileModel),
      ],
      verify: (bloc) {
        verify(_profileRepositoryMock.likeStory(_profileModel.stories.first));

        expect(
            (bloc.state as StoriesLikedState).profileModel.stories.first.likes,
            1);
      },
    );

    blocTest<StoriesBloc, StoriesState>(
      "Doit permettre de ne plus liker une story",
      build: () {
        when(_profileRepositoryMock.likeStory(_profileModel.stories.first))
            .thenAnswer((realInvocation) => Future.value(false));

        StoriesBloc storiesBloc = StoriesBloc(_profileRepositoryMock);

        _profileModel.stories.first.likes = 1;

        storiesBloc.emit(StoriesLoadedState(
          profileModel: _profileModel,
        ));

        return storiesBloc;
      },
      act: (bloc) => bloc.add(LikeStoriesEvent(_profileModel.stories.first)),
      expect: () => [
        StoriesLikeInProgressState(_profileModel),
        StoriesUnlikedState(profileModel: _profileModel),
      ],
      verify: (bloc) {
        verify(_profileRepositoryMock.likeStory(_profileModel.stories.first));

        expect(
          (bloc.state as StoriesUnlikedState).profileModel.stories.first.likes,
          0,
        );
      },
    );
  });
}
