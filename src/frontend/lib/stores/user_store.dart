import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UsersStore {

  UsersStore ();

  /// Creates collection in Firestore
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future addNewUser(String email, String pwd) async {
    var addUserData = Map<String, dynamic>();
    addUserData['e-mail'] = email;
    addUserData['pwd'] = pwd;
    // TODO: set user reference of field
    return usersCollection.doc().set(addUserData);
  }

}