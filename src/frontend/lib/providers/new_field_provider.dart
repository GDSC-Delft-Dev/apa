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
  Polygon getPolygon(
      {Color strokeColor = Colors.orange,
      Color fillColor = Colors.transparent,
      int strokeWidth = 3}) {
    return Polygon(
      polygonId: const PolygonId("newField"),
      points: _geoPoints.map((f) => LatLng(f.latitude, f.longitude)).toList(),
      strokeWidth: strokeWidth,
      strokeColor: strokeColor,
      fillColor: fillColor,
    );
  }

  // Adds a geopoint to the list of geopoints.
  void addGeoPoint(GeoPoint geoPoint) {
    _geoPoints.add(geoPoint);
    notifyListeners();
  }

  void addGeoPointWithPoint(Point point) {
    addGeoPoint(GeoPoint(point.x.toDouble(), point.y.toDouble()));
  }

  void addGeoPointWithLatLong(LatLng latLng) {
    addGeoPoint(GeoPoint(latLng.latitude, latLng.longitude));
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
    
    return _geoPoints.length >= 3 && !utils.checkIfPolygonIsSelfIntersecting(_geoPoints);
  }
}
