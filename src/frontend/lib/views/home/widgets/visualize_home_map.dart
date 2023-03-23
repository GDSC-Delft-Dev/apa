import 'dart:ui' as ui;

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/providers/map_settings_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/utils/polygon_utils.dart';
import 'package:frontend/views/insights/insights_wrapper.dart';
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

  // For keeping track of polygons to  draw
  Set<Polygon> _polygons = Set<Polygon>();

  // For showing the name of the fields
  Set<Marker> _markers = Set<Marker>();

  // Reads JSON to locate to location that was searched for
  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }

  // getBytesFromCanvas is a function that takes a width, height, and text and
  // returns a Uint8List of the text rendered on a canvas
  Future<Uint8List> getBytesFromCanvas(int width, int height, String text) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.green;

    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);
    final double fontSize = 64;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (width - textPainter.width) / 2,
        (height - textPainter.height) / 2,
      ),
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(width, height);
    final ByteData? byteData  = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return pngBytes;
  }

  /// Takes a list of field models and created polygons to draw on the map
  _convertFieldsToPolygons(List<FieldModel> fields) async {
    // TODO: add custom marker (pin) that has field name as label
    for (var field in fields) {
      // Convert from List<GeoPoint> to List<LatLng>
      List<LatLng> fieldBoundaries = field.boundaries.map((f) =>
          LatLng(f.latitude, f.longitude)).toList();
      _polygons.add(
          Polygon(
              polygonId: PolygonId(field.fieldId),
              points: fieldBoundaries,
              strokeColor: Colors.green,
              
              strokeWidth: 5,
              fillColor: Colors.green.withOpacity(0.2),
              consumeTapEvents: true,
              onTap: () {
                // Opens the field details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsightsWrapper(
                      fieldId: field.fieldId,
                    ),
                  ),
                );

              }
          )
      );
      _markers.add(
          Marker(
              markerId: MarkerId(field.fieldId),
              position: getCenterOfPolygon(fieldBoundaries),
              infoWindow: InfoWindow(title: ""),
              // Show the name of the field directly on the map as icon
              icon: BitmapDescriptor.fromBytes(
                await getBytesFromCanvas(field.fieldName.length * 35, 100, field.fieldName)),
              
              onTap: () {
                // Opens the field details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsightsWrapper(
                      fieldId: field.fieldId,
                    ),
                  ),
                );
              }
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
            return Loading();
          }
          return Stack(
            children: [
              
              Consumer<MapSettingsProvider>(
                  builder: (context, mapSettings, child) {
                    return Expanded(
                      child: Stack(
                        children: <Widget>[
                          GoogleMap(
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            mapToolbarEnabled: false,
                            compassEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: mapSettings.cameraPosition,
                            mapType: mapSettings.mapType,
                            markers: _markers,
                            polygons: _polygons,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            onCameraMove: (camera) =>
                                mapSettings.setCameraPosition(camera),
                            onTap: (point) => print('------- TAPPED ------ $point'),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 25, right: 12),
                            alignment: Alignment.topRight,
                            child: Column(
                              children: <Widget>[
                                FloatingActionButton(
                                  backgroundColor: Colors.lightBlue,
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
              Container(
                padding: EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(20, 20, 80, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(hintText: 'Search by city'),
                        textAlign: TextAlign.left,
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
              ),
            ],
          );
        },
      ),
    );
  }
}

