import 'package:flutter/material.dart';
import 'package:frontend/views/authenticate/authenticate.dart';
import 'package:frontend/views/mainpage.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

/// Listens for authentication changes using Firebase streams
/// TODO: Will return main page if logged in or login screen if not logged in
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Access user data retrieved from StreamProvider in main.dart
    final user = Provider.of<Farmer>(context);
    print(user);

    // Return either the MainPage or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return MainPage();
    }

  }
}