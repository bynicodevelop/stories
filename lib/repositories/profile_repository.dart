import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/story_model.dart';

class ProfileRepository {
  FirebaseFirestore _firestore;

  ProfileRepository(this._firestore);

  Future<List<ProfileModel>> get profiles async =>
      Future.delayed(Duration(seconds: 2)).then(
        (value) => <ProfileModel>[
          ProfileModel(
              slug: "johndoe",
              displayName: "John Doe",
              avatar:
                  "https://images.pexels.com/photos/3429740/pexels-photo-3429740.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
              stories: [
                StoryModel(
                  uid: "StoryModel4",
                  storyPath:
                      "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2500439112.mp4?alt=media&token=3f7aef13-5ccb-4227-8afd-5de45d9d9495",
                  likes: 0,
                ),
                StoryModel(
                  uid: "StoryModel4",
                  storyPath:
                      "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2144359980.mp4?alt=media&token=972ed0d4-d14e-4ed5-b0f2-8930494774db",
                  likes: 1234,
                )
              ]),
          ProfileModel(
              slug: "janedoe",
              displayName: "Jane Doe",
              avatar:
                  "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
              stories: [
                StoryModel(
                  uid: "StoryModel3",
                  storyPath:
                      "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2144359980.mp4?alt=media&token=972ed0d4-d14e-4ed5-b0f2-8930494774db",
                  likes: 1112345,
                ),
              ])
        ],
      );

  Future<bool> likeStory(StoryModel storyModel) async {
    return true;
  }

  Future<ProfileModel?> profileBySlug(String slug) async => await Future.value(
        [
          ProfileModel(
            slug: "johndoe",
            displayName: "John Doe",
            avatar:
                "https://images.pexels.com/photos/3429740/pexels-photo-3429740.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
            stories: [
              StoryModel(
                uid: "StoryModel1",
                storyPath:
                    "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2500439112.mp4?alt=media&token=3f7aef13-5ccb-4227-8afd-5de45d9d9495",
              ),
              StoryModel(
                uid: "StoryModel2",
                storyPath:
                    "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2144359980.mp4?alt=media&token=972ed0d4-d14e-4ed5-b0f2-8930494774db",
              )
            ],
          ),
          ProfileModel(
            slug: "janedoe",
            displayName: "John Doe",
            avatar:
                "https://images.pexels.com/photos/3429740/pexels-photo-3429740.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
            stories: [
              StoryModel(
                uid: "StoryModel1",
                storyPath:
                    "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2500435977.mp4?alt=media&token=2207806d-731a-4810-9c1c-366d88bd7851",
              ),
              StoryModel(
                uid: "StoryModel2",
                storyPath:
                    "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2143313667.mp4?alt=media&token=925aa854-353e-4d00-a02b-3d01d9299ddb",
              )
            ],
          ),
        ].firstWhere((profile) => profile.slug == slug),
      );
}
