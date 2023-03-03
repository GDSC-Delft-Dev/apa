import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/utils/polygon_utils.dart' as utils;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// This class is used to share the coordinates of the field to be added.
class NewFieldProvider extends ChangeNotifier {
  List<GeoPoint> _geoPoints = [];
  List<GeoPoint> get geoPoints => _geoPoints;

  // Converts the geopoints to a polygon and returns it.
  Polygon getPolygon() {
    return Polygon(
      polygonId: const PolygonId("newField"),
      points: _geoPoints.map((f) => LatLng(f.latitude, f.longitude)).toList(),
      strokeWidth: 3,
      strokeColor: Colors.orange,
      fillColor: Colors.transparent,
    );
  }

  // Adds a geopoint to the list of geopoints.
  bool addGeoPoint(GeoPoint geoPoint) {
    _geoPoints.add(geoPoint);
    if (utils.checkIfPolygonIsSelfIntersecting(_geoPoints)) {
      _geoPoints.removeLast();
      return false;
    }

    notifyListeners();
    return true;
  }

  bool addGeoPointWithPoint(Point point) {
    return addGeoPoint(GeoPoint(point.x.toDouble(), point.y.toDouble()));
  }

  bool addGeoPointWithLatLong(LatLng latLng) {
    return addGeoPoint(GeoPoint(latLng.latitude, latLng.longitude));
  }

  void removeLastGeoPoint() {
    if (_geoPoints.isNotEmpty) {
      _geoPoints.removeLast();
      notifyListeners();
    }
  }

  void clearGeoPoints() {
    _geoPoints.clear();
    notifyListeners();
  }

  void setGeoPoints(List<GeoPoint> geoPoints) {
    _geoPoints = geoPoints;
    notifyListeners();
  }

  void setGeoPointsFromFieldModel(FieldModel fieldModel) {
    _geoPoints = fieldModel.boundaries;
    notifyListeners();
  }

  void setGeoPointsFromPoints(List<Point> points) {
    _geoPoints = utils.convertToGeoPoints(points);
    notifyListeners();
  }

  List<Point> getPoints() {
    return utils.convertToPoints(_geoPoints);
  }

  bool isPolygonReady() {
    return _geoPoints.length >= 3;
  }

  /// Returns a camera position that is good for the current polygon.
  CameraPosition getGoodCameraPositionForPolygon() {
    if (_geoPoints.isEmpty) {
      return const CameraPosition(
        target: LatLng(0, 0),
        zoom: 0,
      );
    }

    double minLat = _geoPoints[0].latitude;
    double maxLat = _geoPoints[0].latitude;
    double minLong = _geoPoints[0].longitude;
    double maxLong = _geoPoints[0].longitude;

    for (var geoPoint in _geoPoints) {
      minLat = min(minLat, geoPoint.latitude);
      maxLat = max(maxLat, geoPoint.latitude);
      minLong = min(minLong, geoPoint.longitude);
      maxLong = max(maxLong, geoPoint.longitude);
    }

    // The zoom level is calculated using this formula
    var zoom = log(360 / (maxLong - minLong)) / log(2)*0.9;

    return CameraPosition(
      target: LatLng((minLat + maxLat) / 2, (minLong + maxLong) / 2),
      zoom: zoom,
    );
  }
}
