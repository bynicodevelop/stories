class StoryModel {
  final String uid;
  final String storyPath;
  int likes;

  StoryModel({
    required this.uid,
    required this.storyPath,
    this.likes = 0,
  });

  void incrementLike() => likes++;

  void decrementLike() => likes--;
}
