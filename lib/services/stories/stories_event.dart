part of 'stories_bloc.dart';

abstract class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object> get props => [];
}

class LoadStoriesEvent extends StoriesEvent {
  final String slug;

  LoadStoriesEvent(this.slug);
}

class LikeStoriesEvent extends StoriesEvent {
  final StoryModel storyModel;

  LikeStoriesEvent(this.storyModel);
}
