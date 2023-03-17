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

// Fetches scan for which scanId matches
// This can entry may contain urls to images for NDVI or RGB maps
exports.fetchScan = functions.https.onCall(async (data, context) => {
  const scanId = data.scanId;
  // Verify user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated", "User is not authenticated.");
  }
  // Fetch scan document from Firestore
  const scanDoc = await admin.firestore().collection("scans").doc(scanId).get();
  if (!scanDoc.exists) {
    throw new functions.https.HttpsError(
      "not-found", "Scan document not found.");
  }
  // Return the scan data
  const scanData = scanDoc.data();
  return {scanData};
});
