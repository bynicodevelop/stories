import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/story_model.dart';
import 'package:kdofavoris/repositories/profile_repository.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final ProfileRepository _profileRepository;

  StoriesBloc(this._profileRepository)
      : super(
          StoriesInitialState(
            profileModel: ProfileModel(
              slug: "",
              displayName: "",
              avatar: "",
            ),
          ),
        );

  @override
  Stream<StoriesState> mapEventToState(
    StoriesEvent event,
  ) async* {
    if (event is LoadStoriesEvent) {
      yield StoriesLoadingState();

      try {
        ProfileModel? profileModel =
            await _profileRepository.profileBySlug(event.slug);

        if (profileModel == null) {
          yield StoriesErrorState(StoriesErrorStatus.noFound);
          return;
        }

        yield StoriesLoadedState(
          profileModel: profileModel,
        );
      } catch (e) {
        print(e);
      }
    } else if (event is LikeStoriesEvent) {
      yield StoriesLikeInProgressState(
          (state as StoriesInitialState).profileModel);

      bool isLiked = await _profileRepository.likeStory(event.storyModel);

      int index = (state as StoriesInitialState)
          .profileModel
          .stories
          .indexWhere((story) => story.uid == event.storyModel.uid);

      if (isLiked) {
        (state as StoriesInitialState)
            .profileModel
            .stories[index]
            .incrementLike();
      } else {
        (state as StoriesInitialState)
            .profileModel
            .stories[index]
            .decrementLike();
      }

      yield isLiked
          ? StoriesLikedState(
              profileModel: (state as StoriesInitialState).profileModel)
          : StoriesUnlikedState(
              profileModel: (state as StoriesInitialState).profileModel);
    }
  }
}
