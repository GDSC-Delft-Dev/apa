import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {

  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text('Profile info and settings here', style: TextStyle(fontSize: 50),),
        )
    );
  }

}