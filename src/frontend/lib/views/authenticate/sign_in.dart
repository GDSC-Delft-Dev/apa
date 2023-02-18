import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
        elevation: 0.0,
        title: Text('Welcome to TerraFarm'),
        ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                onChanged: (val) {
                  // TODO: validate user email
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true, // hide password entered
                onChanged: (val) {
                  // TODO: validate user password
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                onPressed: () async {
                    // TODO: talk to Firebase Auth
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}