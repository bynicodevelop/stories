import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/story_model.dart';

class ProfileRepository {
  FirebaseFirestore _firestore;

  ProfileRepository(this._firestore);

  Future<List<ProfileModel>> get profiles async {
    QuerySnapshot userQuerySnapshot =
        await _firestore.collection("users").get();

    return Future.wait(
      userQuerySnapshot.docs.map((doc) async {
        QuerySnapshot postQuerySnapshot = await _firestore
            .collection("posts")
            .where("userRef", isEqualTo: doc.reference)
            .limit(1)
            .get();

        return ProfileModel(
            slug: doc.data()["slug"],
            displayName: doc.data()["displayName"],
            avatar: doc.data()["avatar"],
            stories: [
              StoryModel(
                uid: postQuerySnapshot.docs.first.id,
                storyPath: postQuerySnapshot.docs.first.data()["media"],
                likes: postQuerySnapshot.docs.first.data()["likes"],
              )
            ]);
      }),
    );
  }

  Future<bool> likeStory(StoryModel storyModel) async {
    return true;
  }

  Future<ProfileModel?> profileBySlug(String slug) async {
    QuerySnapshot profileQuerySnapshot = await _firestore
        .collection("users")
        .where("slug", isEqualTo: slug)
        .limit(1)
        .get();

    if (profileQuerySnapshot.docs.length == 0) {
      return null;
    }

    QueryDocumentSnapshot userQueryDocumentSnapshot =
        profileQuerySnapshot.docs.first;

    QuerySnapshot postQuerySnapshot = await _firestore
        .collection("posts")
        .where("userRef", isEqualTo: userQueryDocumentSnapshot.reference)
        .get();

    return ProfileModel(
      slug: userQueryDocumentSnapshot.data()["slug"],
      displayName: userQueryDocumentSnapshot.data()["displayName"],
      avatar: userQueryDocumentSnapshot.data()["avatar"],
      stories: postQuerySnapshot.docs
          .map((doc) => StoryModel(uid: doc.id, storyPath: doc.data()["media"]))
          .toList(),
    );
  }
}
