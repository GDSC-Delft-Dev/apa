import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/user_model.dart';

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

  // Register with email and password

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