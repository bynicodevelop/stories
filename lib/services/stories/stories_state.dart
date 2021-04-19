part of 'stories_bloc.dart';

enum StoriesErrorStatus { noFound }

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

class StoriesInitialState extends StoriesState {
  final ProfileModel profileModel;

  StoriesInitialState({
    required this.profileModel,
  });

  StoriesInitialState copyWith({
    ProfileModel? profileModel,
  }) =>
      StoriesInitialState(
        profileModel: profileModel ?? this.profileModel,
      );

  @override
  List<Object> get props => [profileModel];
}

class StoriesLoadingState extends StoriesState {}

class StoriesLoadedState extends StoriesInitialState {
  StoriesLoadedState({
    required ProfileModel profileModel,
  }) : super(
          profileModel: profileModel,
        );
}

class StoriesLikeInProgressState extends StoriesInitialState {
  StoriesLikeInProgressState(
    ProfileModel profileModel,
  ) : super(
          profileModel: profileModel,
        );
}

class StoriesLikedState extends StoriesInitialState {
  StoriesLikedState({required ProfileModel profileModel})
      : super(
          profileModel: profileModel,
        );
}

class StoriesUnlikedState extends StoriesInitialState {
  StoriesUnlikedState({required ProfileModel profileModel})
      : super(
          profileModel: profileModel,
        );
}

class StoriesErrorState extends StoriesState {
  final StoriesErrorStatus storiesErrorStatus;

  StoriesErrorState(this.storiesErrorStatus);
}
