import 'package:flutter/material.dart';

class FlyDrone extends StatefulWidget {

  const FlyDrone({super.key, required this.droneName});

  final String droneName;

  @override
  _FlyDroneState createState() => _FlyDroneState();

}

class _FlyDroneState extends State<FlyDrone> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fly drone'),
        ),
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text('User can select field to fly over here', style: TextStyle(fontSize: 50),),
        )
    );
  }
}