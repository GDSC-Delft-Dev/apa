import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {

  // Depending on whether the map is related to Home, Add, or Insights, the UI is modified accordingly
  final String context;

  const MyMap({super.key, required this.context});

  @override
  State<MyMap> createState() => _MyMapState();
}

// TODO: change UI according to context field
class _MyMapState extends State<MyMap> {

  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  // Workaround lagging screen due to Google Maps initialization
  final Future _mapFuture = Future.delayed(const Duration(milliseconds: 250), () => true);
  static const LatLng _kMapDelft = LatLng(51.984925, 4.322979);
  MapType _currentMapType = MapType.hybrid;

  // TODO: turn this initial position into users current location
  static const CameraPosition _kInitialPosition =
  CameraPosition(target: _kMapDelft, zoom: 15.0, tilt: 0, bearing: 0);

  static final Marker _exampleMarker = Marker(
    markerId: const MarkerId('_exampleMarker'),
    infoWindow: const InfoWindow(title: 'Corn Field 3'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    position: _kMapDelft,
  );

  static final Polygon _exampleField = const Polygon(
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

  /// Changes map from hybrid into terrain map or vice versa
  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.hybrid
          ? MapType.normal
          : MapType.hybrid;
    });
  }


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: 'Search by city'), textAlign: TextAlign.center,
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                  IconButton(onPressed: () async {
                    var place = await LocationService().getPlace(_searchController.text);
                    _goToPlace(place);
                  }, icon: Icon(Icons.search),),
                ],
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    mapToolbarEnabled: false,
                    initialCameraPosition: _kInitialPosition,
                    mapType: _currentMapType,
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
                    Container(
                      padding: const EdgeInsets.only(top: 24, right: 12),
                      alignment: Alignment.topRight,
                      child: Column(
                        children: <Widget>[
                          FloatingActionButton(
                              backgroundColor: Colors.blueAccent[100],
                              child: const Icon(Icons.map_rounded),
                              onPressed: _changeMapType
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
