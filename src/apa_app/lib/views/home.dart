import 'package:flutter/material.dart';
import 'package:apa_app/views/loading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      body: GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14),
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


