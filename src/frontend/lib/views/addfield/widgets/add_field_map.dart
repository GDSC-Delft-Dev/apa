import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/map_settings_provider.dart';
import 'package:frontend/providers/new_field_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

/// This widget is used to display the map on the add field screen.
/// And it allows for the user to tap the screen to add a new point to the field.
class AddFieldMap extends StatefulWidget {
  const AddFieldMap({super.key});

  @override
  State<AddFieldMap> createState() => _AddFieldMapState();
}

class _AddFieldMapState extends State<AddFieldMap> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<MapSettingsProvider>(builder: (context, mapSettings, child) {
              return Stack(
                children: <Widget>[
                  GoogleMap(

                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    mapToolbarEnabled: false,
                    initialCameraPosition: mapSettings.cameraPosition,
                    mapType: mapSettings.mapType,
                    onCameraMove: (camera) => mapSettings.setCameraPosition(camera),
                    polygons: Provider.of<NewFieldProvider>(context).geoPoints.isNotEmpty
                        ? {
                            Provider.of<NewFieldProvider>(context).getPolygon(
                              fillColor: Colors.green.withOpacity(0.5),
                              strokeColor: Colors.green,
                            )
                          }
                        : {},
                    circles: Provider.of<NewFieldProvider>(context)
                        .geoPoints
                        .map((e) => Circle(
                              circleId: CircleId(e.latitude.toString() + e.longitude.toString()),
                              center: LatLng(e.latitude, e.longitude),
                              radius: 5,
                              fillColor: e == Provider.of<NewFieldProvider>(context).geoPoints.last
                                  ? Colors.lightGreenAccent
                                  : Colors.green,
                              strokeWidth: 0,
                            ))
                        .toSet(),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    

                    onTap: (point) {
                      Provider.of<NewFieldProvider>(context, listen: false)
                          .addGeoPointWithLatLong(point);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 25, right: 12),
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget>[
                        FloatingActionButton(
                            backgroundColor: Colors.blueAccent[100],
                            child: const Icon(Icons.map_rounded),
                            onPressed: () {
                              mapSettings.toggleMapType();
                            }),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
