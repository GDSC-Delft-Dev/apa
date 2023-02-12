import 'dart:async';

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

  Completer<GoogleMapController> _controller = Completer();

  // Workaround lagging screen due to Google Maps initialization
  Future _mapFuture = Future.delayed(Duration(milliseconds: 250), () => true);

  static final LatLng _kMapDelft = LatLng(51.984925, 4.322979);

  static final CameraPosition _kInitialPosition =
  CameraPosition(target: _kMapDelft, zoom: 15.0, tilt: 0, bearing: 0);

  static final Marker _insightMarker = Marker(
      markerId: MarkerId('_insightMarker'),
      infoWindow: InfoWindow(title: 'Corn Field 3'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      position: _kMapDelft,
  );

  static final Polygon _kPolyField = Polygon(
      polygonId: PolygonId('k_PolyField'),
      points: [
        LatLng(51.987308, 4.324069),
        LatLng(51.987179, 4.321984),
        LatLng(51.982814, 4.318815),
        LatLng(51.980851, 4.319083),
        LatLng(51.981906, 4.325687)
      ],
      strokeColor: Colors.orange,
      strokeWidth: 5,
      fillColor: Colors.transparent
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _mapFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("Empty");
            return Container();
          }
          return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapToolbarEnabled: false,
            initialCameraPosition: _kInitialPosition,
            mapType: MapType.hybrid,
            markers: {_insightMarker},
            polygons: {_kPolyField},
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          );
        },
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


