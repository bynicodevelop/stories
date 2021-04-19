part of 'stories_bloc.dart';

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

class StoriesInitialState extends StoriesState {}

class StoriesLoadingState extends StoriesState {}

class StoriesLoadedState extends StoriesState {
  final ProfileModel profileModel;

  StoriesLoadedState(this.profileModel);
}
