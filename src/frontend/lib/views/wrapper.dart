import 'package:flutter/material.dart';
import 'package:frontend/views/mainpage.dart';

/// Will return either the home screen or login screen upon entering the app
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    // if (user == null){
    //   return Authenticate();
    // } else {
      return MainPage();
    // }

  }
}