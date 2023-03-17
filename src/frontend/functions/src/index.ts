import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();
// const fcm = admin.messaging();

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

exports.checkHealth = functions.https.onCall(async (data, context) => {
  return "The function is online";
});
