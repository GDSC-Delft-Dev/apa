import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

/// This class is used to store the map settings, i.e. keeping track of camera positions and map type through screens
/// We store this info as to have a seamless transition between the home and the add field screen.
class MapSettingsProvider extends ChangeNotifier {
  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;

  void setMapType(MapType mapType) {
    _mapType = mapType;
    notifyListeners();
  }

  void toggleMapType() {
    _mapType = _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    notifyListeners();
  }

  /// The default position is set to 0,0 and zoom level 0.
  CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 0,
  );

  CameraPosition get cameraPosition => _cameraPosition;

  void setCameraPosition(CameraPosition cameraPosition) {
    _cameraPosition = cameraPosition;
    notifyListeners();
  }
}
