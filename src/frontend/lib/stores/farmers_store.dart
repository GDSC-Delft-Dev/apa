import 'package:cloud_firestore/cloud_firestore.dart';

class FarmersStore {

  final String uid;

  FarmersStore({required this.uid});

  // Creates collection in Firestore
  final CollectionReference farmersCollection = FirebaseFirestore.instance.collection('farmers');

  Future updateUserData(String uid, String email, String pwd) async {
    return await farmersCollection.doc(uid).set({
      'email': email,
      'pwd': pwd
    });
  }

}