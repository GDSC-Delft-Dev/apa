import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';

import '../../widgets/text_input.dart';
import '../loading.dart';

class Register extends StatefulWidget {

  final toggleView;

  // final Function toggleView;
  // const Register({ required this.toggleView });
  const Register({ required this.toggleView });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


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
      title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text('Terrafarm', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, fontFamily: 'Times New Roman')),
              ),
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
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true); // Show loading screen
                    dynamic result = await _auth.registerWithEmailAndPwd(email, pwd);
                    if (result == null) {
                      setState(() => error = 'Please supply a valid e-mail!');
                      loading = false; // Go back to login screen
                    }
                  }
                },
              ),
              ElevatedButton(
                child: Text ('Login using existing account', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey
                ),
                onPressed: () => widget.toggleView(),
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
