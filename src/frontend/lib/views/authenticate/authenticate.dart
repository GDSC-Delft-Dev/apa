import 'package:flutter/material.dart';
import 'package:frontend/views/authenticate/register.dart';
import 'package:frontend/views/authenticate/sign_in.dart';

/// This screen handles user authentication (logging in e.g.)
class Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  /// Allows for switching between login and register forms
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}