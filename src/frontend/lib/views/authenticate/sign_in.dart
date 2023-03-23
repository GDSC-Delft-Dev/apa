import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import '../loading.dart';

/// This screen allows user sign-in using e-mail and password
class SignIn extends StatefulWidget {

  final toggleView;

  SignIn({ required this.toggleView });

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

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SingleChildScrollView (
            reverse: true,
            child: Column(
              children: <Widget>[
                Container(
                  height: height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/farm-background.jpg'),
                      fit: BoxFit.fill
                    )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          width: width * 0.5,
                          height: height * 0.2,
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/drone.png')
                              )
                            ),
                          )
                      ),
                      Positioned(
                        height: height * 0.5,
                        width: width,
                        child: const Center(
                          child: Text('Welcome back to Terrafarm', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white))
                        ),
                      ),
                      Positioned (
                        top: height * 0.4,
                        height: height,
                        width: width,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'E-mail',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    prefixIcon: Icon(Icons.mail_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (val) => val!.isEmpty ? 'Enter an e-mail' : null,
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  obscureText: true, // hide password entered
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    prefixIcon: Icon(Icons.key),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                                  onChanged: (val) {
                                    setState(() => pwd = val);
                                  },
                                ),
                                const SizedBox(height: 20.0, width: 50,),
                                ElevatedButton(
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white, fontSize: 17),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: Size(width * 0.7, height * 0.05),
                                    elevation: 20,
                                    shadowColor: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => loading = true); // Show loading screen
                                      dynamic result = await _auth.signInWithEmailAndPwd(email, pwd);
                                      if (result == null) {
                                        setState(() => error = 'Could not sign in with those credentials!');
                                        loading = false; // Remain in current screen
                                      }
                                    }
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text(
                                    'Create an account',
                                    style: TextStyle(color: Colors.white, fontSize: 17),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    primary: Colors.blue[200],
                                    minimumSize: Size(width * 0.7, height * 0.05),
                                    elevation: 20,
                                    shadowColor: Colors.blue,
                                  ),
                                  onPressed: () => widget.toggleView(),
                                ),
                                SizedBox(height: 12.0),
                                Text(
                                  error,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 14.0),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
        
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

    );
  }

}