import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
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
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // A list of settings (about and logout) they should be clickable.
          // When clicked, they should perform the action
          // For example, when the user clicks on logout, they should be logged out
          // and taken to the login screen
          GestureDetector(
            onTap: () {
              // Opens a bottom modal pop up with information about the app
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 60,
                    ),
                    child: Text(
                      'This app was created by the team at the TU Delft for the 2022-2023 Google Solutions Challenge. It was created to help farmers get automated insights about their fields and crops.',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'About',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () async {
              await _auth.signOut();
            },
            child: Container(
              color: Colors.red,
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
