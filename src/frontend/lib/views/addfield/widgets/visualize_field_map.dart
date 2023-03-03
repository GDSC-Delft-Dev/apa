import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/providers/map_settings_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

/// A general map widget that given a position and a polygon 
/// will display the map with the polygon on it.
class VisualizeFieldMap extends StatefulWidget {
  final CameraPosition cameraPosition;
  final Polygon polygon;
  const VisualizeFieldMap({super.key, required this.cameraPosition, required this.polygon});

  @override
  State<VisualizeFieldMap> createState() => _VisualizeFieldMapState();
}

class _VisualizeFieldMapState extends State<VisualizeFieldMap> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Consumer<MapSettingsProvider>(builder: (context, mapSettings, child) {
      return IgnorePointer(
        child: GoogleMap(
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: false,
          mapToolbarEnabled: false,
          buildingsEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          tiltGesturesEnabled: false,
          initialCameraPosition: widget.cameraPosition,
          mapType: mapSettings.mapType,
          polygons: {widget.polygon},
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      );
    });
  }
}
