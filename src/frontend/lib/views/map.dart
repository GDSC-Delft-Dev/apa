import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/field_model.dart';
import 'loading.dart';

class MyMap extends StatefulWidget {

  // Depending on whether the map is related to 'HOME', 'ADD', or 'INSIGHTS', the UI is modified accordingly
  final String parent;
  // In the context of 'INSIGHTS', this stores the id of current field - else ''
  final String currFieldId;

  const MyMap({super.key, required this.parent, this.currFieldId = ''});

  @override
  State<MyMap> createState() => _MyMapState();
}

// TODO: open field details when clicking within corresponding polygon
// TODO: change UI according to context field
// HOME: Display all fields + markers for localized insights + search
// ADD FIELD: Display all fields + markers for localized insights + search + allow for drawing boundaries
// INSIGHTS: Display static map for current field + colors according to index values
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

  // For creating custom polygons by tapping
  Set<Polygon> _polygons = Set<Polygon>();
  // Keeps track of points tapped by user (for adding fields)
  List<LatLng> _pointsTapped = [];
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

  /// Takes a list of LatLng points to create one Polygon
  void _createPolygon(List<LatLng> polygonPoints) {
    final String polygonIdVal = 'user_$_polygonIdCounter';
    // Give each polygon a different id
    _polygonIdCounter++;
    _polygons.add(
        Polygon(
          polygonId: PolygonId(polygonIdVal),
          points: polygonPoints,
          strokeWidth: 3,
          strokeColor: Colors.orange,
          fillColor: Colors.transparent,
        )
    );
  }

  /// Takes a list of field models and created polygons to draw on the map
  _convertFieldsToPolygons(List<FieldModel> fields) {

    for (var field in fields) {
      print('------------------- Drawing field ${field.fieldName}\n\n');
      // Convert from List<GeoPoint> to List<LatLng>
      // In the context of INSIGHTS, only draw current field
      if (widget.parent != 'INSIGHTS' || field.fieldId == widget.currFieldId) {
        List<LatLng> fieldBoundaries = field.boundaries.map((f) => LatLng(f.latitude, f.longitude)).toList();
        _polygons.add(
            Polygon(
                polygonId: PolygonId(field.fieldId),
                points: fieldBoundaries,
                strokeColor: Colors.orange,
                strokeWidth: 5,
                fillColor: widget.parent != 'INSIGHTS' ? Colors.transparent : Colors.orange
            )
        );
      }
    }
  }

  /// Changes map from hybrid into terrain map or vice versa
  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.hybrid
          ? MapType.normal
          : MapType.hybrid;
    });
  }

  /// Clears all points tapped by the user
  void _clearPoints() {
    setState(() {
      _pointsTapped = [];
      // All polygons added by user have PolygonId starting with 'user_'
      _polygons.removeWhere((p) => p.polygonId.value.startsWith('user'));
    });
  }


  @override
  Widget build(BuildContext context) {

    // Refers to the StreamProvider of parent widget Home()
    final fields = Provider.of<List<FieldModel>>(context);
    // Turns all fields fetched from Firestore into polygons to show on map
    _convertFieldsToPolygons(fields);

    return Scaffold(
      body: FutureBuilder(
        future: _mapFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("Empty");
            return Loading();
          }
          return Column(
            children: [
              widget.parent == 'ADD' ?
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Tap on borders for field to add'), textAlign: TextAlign.center,
                      )
                  ),
                  Icon(Icons.draw_sharp),
                ],
              )
              : widget.parent == 'HOME' ? Row(
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
              ) : Row(),
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
                        print('-------- Point tapped: $point');
                        _pointsTapped.add(point);
                        _createPolygon(_pointsTapped);
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
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 95, right: 12),
                      alignment: Alignment.topRight,
                      child: Column(
                        children: <Widget>[
                          widget.parent == 'ADD' ? FloatingActionButton(
                              backgroundColor: Colors.blueAccent[100],
                              onPressed: _clearPoints,
                              child: const Icon(Icons.undo)
                          ) : widget.parent == 'INSIGHTS' ? const FloatingActionButton(
                              backgroundColor: Colors.lightGreenAccent,
                              // TODO: Allow user to pick insight maps
                              onPressed: null,
                              child: Icon(Icons.stacked_line_chart_rounded))
                              : Container()
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
