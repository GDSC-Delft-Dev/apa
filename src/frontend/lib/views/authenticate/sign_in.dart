import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/text_input.dart';
import '../loading.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String pwd = '';
  String error = '';  // in case Firebase auth raises error, we store it in state

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
        elevation: 0.0,
        title: Text('Welcome to Terrafarm'),
        ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: userTextInput.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an e-mail' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true, // hide password entered
                decoration: userTextInput.copyWith(hintText: 'Password'),
                validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
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
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true); // Show loading screen
                    dynamic result = await _auth.signInWithEmailAndPwd(email, pwd);
                    if (result == null) {
                      setState(() => error = 'Could not sign in with those credentials!');
                      loading = false; // Go back to login screen
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