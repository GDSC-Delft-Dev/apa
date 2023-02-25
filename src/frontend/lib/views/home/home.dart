import 'package:flutter/material.dart';
import 'package:frontend/views/addfield/addfield.dart';
import 'package:frontend/views/loading.dart';
import 'package:frontend/views/map.dart';

/// This is the first screen within the application that the user encounters
/// It contains a Google Map to indicate all fields owned by the user
class Home extends StatefulWidget {

  const Home({super.key, required this.title});

  final String title;

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const MyMap(context: 'Home'),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_add',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddField(),
            )
          );
        },
        tooltip: 'Add field',
        child: const Icon(Icons.add, size: 35, color: Colors.white,)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
    );

  }

}


