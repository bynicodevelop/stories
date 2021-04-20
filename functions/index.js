const functions = require("firebase-functions");
const admin = require("firebase-admin");
const dayjs = require("dayjs");

const dataSet = require("./dataset").dataset;

admin.initializeApp();

const COLLECTIONS = {
  USERS: "users",
  POSTS: "posts",
  FOLLOWINGS: "followings",
  FOLLOWERS: "followers",
};

const getUserByUid = async (uid) =>
  await admin.firestore().collection(COLLECTIONS.USERS).doc(uid).get();

const getUserBySlug = async (slug) =>
  await admin
    .firestore()
    .collection(COLLECTIONS.USERS)
    .limit(1)
    .where("slug", "==", slug)
    .get();

const generateDate = (days) => {
  const randomDay = Math.floor(Math.random() * days) + 1;

  return dayjs().subtract(randomDay, "days");
};

exports.populate = functions.https.onRequest(async (request, response) => {
  dataSet.forEach(async (data) => {
    const { slug, displayName, avatar } = data["users"];

    const user = await admin.auth().createUser({
      email: `${slug}@domain.tld`,
      password: "123456",
    });

    const { uid } = user;

    await admin
      .firestore()
      .collection(COLLECTIONS.USERS)
      .doc(uid)
      .set({ displayName, slug, avatar });

    const userRef = await getUserByUid(uid);

    data["posts"].forEach(async (post) => {
      const { media, likes } = post;

      await admin
        .firestore()
        .collection(COLLECTIONS.POSTS)
        .add({
          media,
          likes,
          createdAt: generateDate(300).unix(),
          userRef: userRef.ref,
        });
    });

    if (data["followings"]) {
      data["followings"].forEach(async (followingSlug) => {
        const followingRef = await getUserBySlug(followingSlug);

        if (followingRef.docs.length > 0) {
          const followingUser = followingRef.docs.shift();

          userRef.ref
            .collection(COLLECTIONS.FOLLOWINGS)
            .doc(followingUser.id)
            .set({ userRef: followingUser.ref });
        }
      });
    }
  });

  response.json("ok");
});

/**
 * Permet de créer une relation follower
 * quand un utilisateur follow un profil
 */
exports.onFollowingCreated = functions.firestore
  .document(
    `${COLLECTIONS.USERS}/{userId}/${COLLECTIONS.FOLLOWINGS}/{followingId}`
  )
  .onCreate(async (snap, context) => {
    const { ref } = snap;

    const userFollowingRef = await getUserByUid(context.params.followingId);

    await userFollowingRef.ref
      .collection(COLLECTIONS.FOLLOWERS)
      .doc(context.params.userId)
      .set({
        userRef: ref,
      });
  });

/**
 * Permet de supprimer la relation follower
 * quand un utilisateur unfollow un profil
 */
exports.onFollowingDeleted = functions.firestore
  .document(
    `${COLLECTIONS.USERS}/{userId}/${COLLECTIONS.FOLLOWINGS}/{followingId}`
  )
  .onDelete(async (snap, context) => {
    const userFollowingRef = await getUserByUid(context.params.followingId);

    await userFollowingRef.ref
      .collection(COLLECTIONS.FOLLOWERS)
      .doc(context.params.userId)
      .delete();
  });

/**
 * Permet de créer la relation avec le post
 * venant d'être créé
 */
exports.onPostCreated = functions.firestore
  .document(`${COLLECTIONS.POSTS}/{postId}`)
  .onCreate(async (snap, context) => {
    const { id } = snap;
    const { userRef } = snap.data();

    await userRef
      .collection(COLLECTIONS.POSTS)
      .doc(id)
      .set({ postRef: snap.ref });
  });
