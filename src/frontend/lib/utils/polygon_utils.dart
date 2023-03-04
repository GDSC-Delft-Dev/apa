import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:poly_collisions/poly_collisions.dart';

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

bool checkIfPolygonIsSelfIntersecting(List<GeoPoint> geoPoints) {
  if (geoPoints.length <= 3) {
    return false;
  }

  List<Point> points = convertToPoints(geoPoints);

  var lines = [
    for (var i = 0; i < points.length; i++) [points[i], points[(i + 1) % points.length]]
  ];

  for (var i = 0; i < lines.length; i++) {
    for (var j = i + 2; j < lines.length; j++) {
      if ((j + 1) % lines.length == i) {
        continue;
      }
      if (PolygonCollision.doesOverlap(lines[i], lines[j], type: PolygonType.Concave)) {
        return true;
      }
    }
  }
  return false;
}

// Get the area of a geo polygon
double getGeoArea(List<GeoPoint> geoPoints) {
  var world = {
    'type': 'Polygon',
    'coordinates': [geoPoints.map((e) => [e.latitude, e.longitude]).toList()]
  };
  final geoJSONPolygon = GeoJSONPolygon.fromMap(world);
  return geoJSONPolygon.area;
}
