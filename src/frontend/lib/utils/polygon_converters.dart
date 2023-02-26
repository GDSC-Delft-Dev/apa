import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Point> convertToPoints(List<GeoPoint> geoPoints) {
  List<Point> points = [];
  for (var geoPoint in geoPoints) {
    points.add(Point(geoPoint.latitude, geoPoint.longitude));
  }
  return points;
}

List<GeoPoint> convertToGeoPoints(List<Point> points) {
  List<GeoPoint> geoPoints = [];
  for (var point in points) {
    geoPoints.add(GeoPoint(point.x.toDouble(), point.y.toDouble()));
  }
  return geoPoints;
}