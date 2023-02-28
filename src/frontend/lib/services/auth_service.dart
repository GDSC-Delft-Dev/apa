import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/stores/user_store.dart';

/// Handles user authentication by communicating with Firebase Authentication
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on FirebaseUser
  UserModel? _userModelFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // Listens to authentication changes using Firebase stream
  // Firebase User when user logs in
  // Null when user signs out
  Stream<UserModel?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userModelFromFirebaseUser(user));
  }

  /// Sign in with email and password
  Future signInWithEmailAndPwd(String email, String pwd) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      User? user = credential.user;
      print(user?.uid);
    } on FirebaseAuthException catch (e) {
      print("------------- FIREBASE AUTH ERROR ----------------------");
      print(e.toString());
      if (e.code == 'user-not-found') {
        print('No user with that e-mail!');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user!');
      }
    }
  }

  /// Register with e-mail and password
  Future registerWithEmailAndPwd(String email, String pwd) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: pwd);
      User? user = credential.user;
      // Create new User document in Firestore with randomly generated uid
      await UsersStore().addNewUser(user!.uid, email, pwd);
      return _userModelFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Sign out user
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}