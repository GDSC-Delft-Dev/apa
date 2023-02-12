import 'package:flutter/material.dart';
import 'package:apa_app/views/loading.dart';

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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const SafeArea(
        child: Center (
          child: Text('Interactive map to be added here', style: TextStyle(fontSize: 50),),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Loading(),
            )
          );
        },
        tooltip: 'Add field',
        child: const Icon(Icons.add, size: 35, color: Colors.white,)
      ),
    );

  }

}

