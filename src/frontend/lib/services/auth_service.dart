import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/farmer_model.dart';

/// Handles user authentication by communicating with Firebase Authentication
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on FirebaseUser
  Farmer? _userFromFirebaseUser(User? user) {
    return user != null ? Farmer(uid: user.uid) : null;
  }

  // Listens to authentication changes using Firebase stream
  // Firebase User when user logs in
  // Null when user signs out
  Stream<Farmer?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // Sign in with email and password
  Future signInWithEmailAndPwd(String email, String pwd) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      User? user = credential.user;
      print(user?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user with that e-mail!');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user!');
      }
    }
  }

  // TODO: Register with email and password and call updateUserData in farmers_store

  // Sign out user
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}