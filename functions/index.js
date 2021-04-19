const functions = require("firebase-functions");
const admin = require("firebase-admin");
const dayjs = require("dayjs");

const dataSet = require("./dataset").dataset;

admin.initializeApp();

const COLLECTIONS = {
  USERS: "users",
  POSTS: "posts",
};

const getUserBySlug = async (slug) =>
  await admin.firestore().collection(COLLECTIONS.USERS).doc(slug).get();

const generateDate = (days) => {
  const randomDay = Math.floor(Math.random() * days) + 1;

  return dayjs().subtract(randomDay, "days");
};

exports.populate = functions.https.onRequest(async (request, response) => {
  dataSet.forEach(async (data) => {
    const { slug, displayName } = data["users"];

    await admin
      .firestore()
      .collection(COLLECTIONS.USERS)
      .doc(slug)
      .set({ displayName });

    const userRef = await getUserBySlug(slug);

    data["posts"].forEach(async (post) => {
      const { media } = post;

      await admin
        .firestore()
        .collection(COLLECTIONS.POSTS)
        .add({
          media,
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
