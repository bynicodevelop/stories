import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/story_model.dart';
import 'package:kdofavoris/models/user_model.dart';
import 'package:kdofavoris/repositories/auth_repository.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class UserRepository {
  AuthRepository _authRepository;
  FirebaseFirestore _firebase;

  UserRepository(this._authRepository, this._firebase);

  Future<UserModel> get user async => Future.value(
        UserModel(
            uid: "123456789",
            displayName: "John Doe",
            slug: "johndoe",
            avatar:
                "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
            isAnonymous: false),
      );

  Future<List<ProfileModel>> get followingrs async => await Future.value(
        <ProfileModel>[
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
              )
            ],
          ),
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
            ],
          )
        ],
      );

  Future<List<ProfileModel>> get followers async => Future.value([
        ProfileModel(
          slug: "johndoe",
          displayName: "John Doe",
          avatar:
              "https://images.pexels.com/photos/3429740/pexels-photo-3429740.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
          stories: [],
        ),
        ProfileModel(
          slug: "janndoe",
          displayName: "Jane Doe",
          avatar:
              "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
          stories: [],
        )
      ]);
}
