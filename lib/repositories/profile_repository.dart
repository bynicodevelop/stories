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

    return ProfileModel(
        slug: userQueryDocumentSnapshot.data()["slug"],
        displayName: userQueryDocumentSnapshot.data()["displayName"],
        avatar: userQueryDocumentSnapshot.data()["avatar"]);
  }

  // await Future.value(
  //       [
  //         ProfileModel(
  //           slug: "johndoe",
  //           displayName: "John Doe",
  //           avatar:
  //               "https://images.pexels.com/photos/3429740/pexels-photo-3429740.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
  //           stories: [
  //             StoryModel(
  //               uid: "StoryModel1",
  //               storyPath:
  //                   "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2500439112.mp4?alt=media&token=3f7aef13-5ccb-4227-8afd-5de45d9d9495",
  //             ),
  //             StoryModel(
  //               uid: "StoryModel2",
  //               storyPath:
  //                   "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2144359980.mp4?alt=media&token=972ed0d4-d14e-4ed5-b0f2-8930494774db",
  //             )
  //           ],
  //         ),
  //         ProfileModel(
  //           slug: "janedoe",
  //           displayName: "John Doe",
  //           avatar:
  //               "https://images.pexels.com/photos/3429740/pexels-photo-3429740.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
  //           stories: [
  //             StoryModel(
  //               uid: "StoryModel1",
  //               storyPath:
  //                   "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2500435977.mp4?alt=media&token=2207806d-731a-4810-9c1c-366d88bd7851",
  //             ),
  //             StoryModel(
  //               uid: "StoryModel2",
  //               storyPath:
  //                   "https://firebasestorage.googleapis.com/v0/b/formation-a1ba5.appspot.com/o/2143313667.mp4?alt=media&token=925aa854-353e-4d00-a02b-3d01d9299ddb",
  //             )
  //           ],
  //         ),
  //       ].firstWhere((profile) => profile.slug == slug),
  //     );
}
