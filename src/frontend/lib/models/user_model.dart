/// Represents a user of the Terrafarm app
/// Note that "UserModel" is used rather than "User", in order to distinguish between our model and the Firebase User class
class UserModel {

  final String uid;

  UserModel({ required this.uid });

}