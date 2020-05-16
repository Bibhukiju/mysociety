const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.onCreateFollower = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onCreate(async (snapshot, context) => {
    console.log("follower created", snapshot.data());
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const followedUserRef = admin
      .firestore()
      .collection("posts")
      .doc(userId)
      .collection("userPosts");

    const timeLinePostsRef = admin
      .firestore()
      .collection("timeline")
      .doc(followerId)
      .collection("timelinePosts");

    const querySnapshot = await followedUserRef.get();

    querySnapshot.forEach((doc) => {
      if (doc.exists) {
        const postId = doc.id;
        const postdata = doc.data();
        timeLinePostsRef.doc(postId).set(postdata);
      }
    });
  });

exports.onDeleteFollower = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onDelete(async (snapshot, context) => {
    console.log("followers Deleted", snapshot.id);
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const timeLinePostsRef = admin
      .firestore()
      .collection("timeline")
      .doc(followerId)
      .collection("timelinePosts")
      .where("ownerId", "==", userId);
    const querySnapshot = await timeLinePostsRef.get();
    querySnapshot.forEach((doc) => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  });

exports.onCreatePost = functions.firestore
  .document("/posts/{userId}/userPosts/{postId}")
  .onCreate(async (snapshot, context) => {
    const postCreated = snapshot.data();
    const userId = context.params.userId;
    const postId = context.params.postId;

    const userFollowerRef = admin
      .firestore()
      .collection("followers")
      .doc(userId)
      .collection("userFollowers");

    const querySnapshot = await userFollowerRef.get();
    querySnapshot.forEach((doc) => {
      const followerId = doc.id;
      admin
        .firestore()
        .collection("timeline")
        .doc(followerId)
        .collection("timelinePosts")
        .doc(postId)
        .set(postCreated);
    });
  });

exports.onUpdate = functions.firestore
  .document("/posts/{userId}/userPosts/{postId}")
  .onUpdate(async (change, context) => {
    const postUpdated = change.after.data();
    const userId = context.params.userId;
    const postId = context.params.postId;
    const userFollowerRef = admin
      .firestore()
      .collection("followers")
      .doc(userId)
      .collection("userFollowers");
    const querySnapshot = await userFollowerRef.get();
    querySnapshot.forEach((doc) => {
      const followerId = doc.id;
      admin
        .firestore()
        .collection("timeline")
        .doc(followerId)
        .collection("timelinePosts")
        .doc(postId)
        .get()
        .then((doc) => {
          if (doc.exists) {
            doc.ref.update(postUpdated);
          }
        });
    });
  });
exports.onDelete = functions.firestore
  .document("/posts/{userId}/userPosts/{postId}")
  .onDelete(async (snapshot, context) => {
    const userId = context.params.userId;
    const postId = context.params.postId;
    const userFollowerRef = admin
      .firestore()
      .collection("followers")
      .doc(userId)
      .collection("userFollowers");
    const querySnapshot = await userFollowerRef.get();
    querySnapshot.forEach((doc) => {
      const followerId = doc.id;
      admin
        .firestore()
        .collection("timeline")
        .doc(followerId)
        .collection("timelinePosts")
        .doc(postId)
        .get()
        .then((doc) => {
          if (doc.exists) {
            doc.ref.delete();
          }
        });
    });
  });

exports.onCreateActivityFeedItem = functions.firestore
  .document("/feed/{userId}/feedItems/{activityFeedItem}")
  .onCreate(async (snapshot, context) => {
    console.log("a", snapshot.data());
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();
    const createdactivityFeedItem = snapshot.data();
    const andriodNotificationToken = doc.data().andriodNotificationToken;
    if (andriodNotificationToken) {
      //send notifications
      sendNotification(andriodNotificationToken, createdactivityFeedItem);
    } else {
      console.log("no token ");
    }
    function sendNotification(andriodNotificationToken, activityFeedItem) {
      let body;
      //switch body value based on notificationtype
      switch (activityFeedItem.type) {
        case "comment":
          body = `${activityFeedItem.username} replied: 
          ${activityFeedItem.commentData}`;
          break;
        case "like":
          body = `${activityFeedItem.username} liked: your post`;
          break;
        case "follow":
          body = `${activityFeedItem.username} started following you`;
          break;
        default:
          break;
      }
      const message = {
        notification: { body },
        token: andriodNotificationToken,
        data: { recipient: userId },
      };
      admin.messaging.send(message).then((response) => {
        console.log("Sent sucess", response);
      });
    }
  });
