import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/story_model.dart';
import 'package:kdofavoris/models/user_model.dart';
import 'package:kdofavoris/repositories/auth_repository.dart';

class UserRepository {
  AuthRepository _authRepository;
  FirebaseFirestore _firebase;

  UserRepository(this._authRepository, this._firebase);

  Future<DocumentSnapshot> _getUserById(String userId) async =>
      await _firebase.collection("users").doc(userId).get();

  Future<UserModel> get user async {
    UserModel? userModel = await _authRepository.user;

    DocumentSnapshot documentSnapshot = await _getUserById(userModel!.uid);

    return UserModel(
      uid: documentSnapshot.id,
      displayName: documentSnapshot.data()!["displayName"],
      avatar: documentSnapshot.data()!["avatar"],
      slug: documentSnapshot.data()!["slug"],
    );
  }

  Future<List<ProfileModel>> get followingrs async {
    UserModel? userModel = await _authRepository.user;

    QuerySnapshot followingsQuerySnapshot = await _firebase
        .collection("users")
        .doc(userModel!.uid)
        .collection("followings")
        .get();

    return Future.wait(followingsQuerySnapshot.docs.map((doc) async {
      DocumentSnapshot userDocumentSnapshot = await _getUserById(doc.id);

      QuerySnapshot postQuerySnapshot = await _firebase
          .collection("posts")
          .where("userRef", isEqualTo: doc.data()["userRef"])
          .get();

      return ProfileModel(
        slug: userDocumentSnapshot.data()!["slug"],
        displayName: userDocumentSnapshot.data()!["displayName"],
        avatar: userDocumentSnapshot.data()!["avatar"],
        stories: postQuerySnapshot.docs
            .map(
              (doc) => StoryModel(
                uid: doc.id,
                storyPath: doc.data()["media"],
              ),
            )
            .toList(),
      );
    }).toList());
  }

  Future<List<ProfileModel>> get followers async {
    UserModel? userModel = await _authRepository.user;

    QuerySnapshot followersQuerySnapshot = await _firebase
        .collection("users")
        .doc(userModel!.uid)
        .collection("followers")
        .get();

    return Future.wait(followersQuerySnapshot.docs.map((doc) async {
      DocumentSnapshot userDocumentSnapshot = await _getUserById(doc.id);

      return ProfileModel(
        slug: userDocumentSnapshot.data()!["slug"],
        displayName: userDocumentSnapshot.data()!["displayName"],
        avatar: userDocumentSnapshot.data()!["avatar"],
      );
    }).toList());
  }
}
