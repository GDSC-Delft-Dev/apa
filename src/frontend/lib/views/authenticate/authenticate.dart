import 'package:flutter/material.dart';
import 'package:frontend/views/authenticate/sign_in.dart';

/// This screen handles user authentication (logging in e.g.)
class Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn(),
    );
  }
}