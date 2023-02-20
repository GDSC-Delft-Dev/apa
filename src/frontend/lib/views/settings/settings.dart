import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';

/// This screen allows users to see their profile info
/// as well as settings
class Settings extends StatefulWidget {

  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Column(
            children: [
              Text('Profile info and settings here', style: TextStyle(fontSize: 50),),
              ElevatedButton(
                  child: Text(
                    'Log out'
                  ),
                onPressed: () async {
                    await _auth.signOut();
                }),
            ],
          ),
        ),
    );
  }

}