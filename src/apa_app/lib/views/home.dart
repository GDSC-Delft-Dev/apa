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

  static final LatLng _kMapCenter = LatLng(51.984925, 4.322979);

  static final CameraPosition _kInitialPosition =
  CameraPosition(target: _kMapCenter, zoom: 15.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
            initialCameraPosition: _kInitialPosition,
            mapType: MapType.hybrid,
            myLocationButtonEnabled: true,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
    );

  }

}


