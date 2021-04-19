import 'package:kdofavoris/models/story_model.dart';

class ProfileModel {
  final String slug;
  final String displayName;
  final String avatar;
  final List<StoryModel> stories;

  ProfileModel({
    required this.slug,
    required this.displayName,
    required this.avatar,
    this.stories = const <StoryModel>[],
  });
}
