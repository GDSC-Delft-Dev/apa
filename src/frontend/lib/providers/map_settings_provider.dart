import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
