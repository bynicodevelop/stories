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
                  uid: "uid",
                  storyPath:
                      "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2500439112.mp4?alt=media&token=3f7aef13-5ccb-4227-8afd-5de45d9d9495",
                ),
                StoryModel(
                  uid: "uid",
                  storyPath:
                      "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2144359980.mp4?alt=media&token=972ed0d4-d14e-4ed5-b0f2-8930494774db",
                )
              ]),
          ProfileModel(
              slug: "janndoe",
              displayName: "Jane Doe",
              avatar:
                  "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
              stories: [
                StoryModel(
                  uid: "uid",
                  storyPath:
                      "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2144359980.mp4?alt=media&token=972ed0d4-d14e-4ed5-b0f2-8930494774db",
                ),
              ])
        ],
      );
}
