import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/map_settings_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../models/field_model.dart';
import '../../loading.dart';

class VisualizeHomeMap extends StatefulWidget {

  // // In the context of 'INSIGHTS', this stores the id of current field - else ''
  // final String currFieldId;

  // const VisualizeHomeMap({super.key, this.currFieldId = ''});

  const VisualizeHomeMap({super.key});

  @override
  State<VisualizeHomeMap> createState() => _VisualizeHomeMapState();
}

// TODO: open field details when clicking within corresponding polygon
class _VisualizeHomeMapState extends State<VisualizeHomeMap> {

  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  // Workaround lagging screen due to Google Maps initialization
  final Future _mapFuture = Future.delayed(
      const Duration(milliseconds: 250), () => true);
  static const LatLng _kMapDelft = LatLng(51.984925, 4.322979);

  // TODO: instead automatically show markers for all localized insights
  static final Marker _exampleMarker = Marker(
    markerId: const MarkerId('_exampleMarker'),
    infoWindow: const InfoWindow(title: 'Corn Field 3'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    position: _kMapDelft,
  );

  // For creating custom polygons by tapping
  Set<Polygon> _polygons = Set<Polygon>();

  // Reads JSON to locate to location that was searched for
  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }


  /// Takes a list of field models and created polygons to draw on the map
  _convertFieldsToPolygons(List<FieldModel> fields) {
    // TODO: add custom marker (pin) that has field name as label
    for (var field in fields) {
      // Convert from List<GeoPoint> to List<LatLng>
      List<LatLng> fieldBoundaries = field.boundaries.map((f) =>
          LatLng(f.latitude, f.longitude)).toList();
      _polygons.add(
          Polygon(
              polygonId: PolygonId(field.fieldId),
              points: fieldBoundaries,
              strokeColor: Colors.orange,
              strokeWidth: 5,
              fillColor: Colors.transparent
          )
      );
    }
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: 'Search by city'),
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                  IconButton(onPressed: () async {
                    var place = await LocationService().getPlace(
                        _searchController.text);
                    _goToPlace(place);
                  }, icon: Icon(Icons.search),),
                ],
              ),
              Consumer<MapSettingsProvider>(
                  builder: (context, mapSettings, child) {
                    return Expanded(
                      child: Stack(
                        children: <Widget>[
                          GoogleMap(
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            mapToolbarEnabled: false,
                            initialCameraPosition: mapSettings.cameraPosition,
                            mapType: mapSettings.mapType,
                            markers: {_exampleMarker},
                            polygons: _polygons,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            onCameraMove: (camera) =>
                                mapSettings.setCameraPosition(camera),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 25, right: 12),
                            alignment: Alignment.topRight,
                            child: Column(
                              children: <Widget>[
                                FloatingActionButton(
                                  backgroundColor: Colors.blueAccent[100],
                                  onPressed: mapSettings.toggleMapType,
                                  child: const Icon(Icons.map_rounded),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ],
          );
        },
      ),
    );
  }
}

