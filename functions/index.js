const functions = require("firebase-functions");
const admin = require("firebase-admin");
const dayjs = require("dayjs");

const dataSet = require("./dataset").dataset;

admin.initializeApp();

const COLLECTIONS = {
  USERS: "users",
  POSTS: "posts",
};

const getUserByUid = async (uid) =>
  await admin.firestore().collection(COLLECTIONS.USERS).doc(uid).get();

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
  });

  response.json("ok");
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
