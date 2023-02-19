import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text field state
  String email = '';
  String pwd = '';
  String error = '';  // in case Firebase auth raises error, we store it in state

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
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Enter an e-mail' : null,
                onChanged: (val) {
                  // TODO: validate user email
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true, // hide password entered
                validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  // TODO: validate user password
                  setState(() => pwd = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                onPressed: () async {
                    // TODO: remove prints
                  print(email);
                  print(pwd);
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.signInWithEmailAndPwd(email, pwd);
                    if (result == null) {
                      setState(() => error = 'Could not sign in with those credentials!');
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.redAccent, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }

}