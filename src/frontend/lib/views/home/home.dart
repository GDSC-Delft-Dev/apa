import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/views/loading.dart';
import 'package:frontend/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {

  const Home({super.key, required this.title});

  final String title;

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  // Workaround lagging screen due to Google Maps initialization
  Future _mapFuture = Future.delayed(Duration(milliseconds: 250), () => true);

  static final LatLng _kMapDelft = LatLng(51.984925, 4.322979);

  static final CameraPosition _kInitialPosition =
  CameraPosition(target: _kMapDelft, zoom: 15.0, tilt: 0, bearing: 0);

  static final Marker _exampleMarker = Marker(
      markerId: MarkerId('_exampleMarker'),
      infoWindow: InfoWindow(title: 'Corn Field 3'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      position: _kMapDelft,
  );

  static final Polygon _exampleField = Polygon(
      polygonId: PolygonId('exampleField'),
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

  // For creating custom polygons by tappingdelft
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  int _polygonIdCounter = 1;

  // Reads JSON to locate to location that was searched for
  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
       CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    // Give each polygon a different id
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 3,
        strokeColor: Colors.orange,
        fillColor: Colors.transparent,
      )
    );
  }

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
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(hintText: 'Search by city'), textAlign: TextAlign.center,
                        onChanged: (value) {
                          print(value);
                        },
                      )
                  ),
                  IconButton(onPressed: () async {
                   var place = await LocationService().getPlace(_searchController.text);
                    _goToPlace(place);
                    }, icon: Icon(Icons.search),),
                ],
              ),
              Expanded(
                child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  mapToolbarEnabled: false,
                  initialCameraPosition: _kInitialPosition,
                  mapType: MapType.hybrid,
                  markers: {_exampleMarker},
                  polygons: _polygons,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (point) {
                    setState(() {
                      polygonLatLngs.add(point);
                      _setPolygon();
                    });
                  },
                ),
              ),
            ],
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


