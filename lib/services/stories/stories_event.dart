part of 'stories_bloc.dart';

abstract class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object> get props => [];
}

class LoadStoriesEvent extends StoriesEvent {
  final ProfileModel profileModel;

  LoadStoriesEvent(this.profileModel);
}
