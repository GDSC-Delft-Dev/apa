import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:poly_collisions/poly_collisions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

// Get the area of a geo polygon in ha
double getGeoArea(List<GeoPoint> geoPoints) {
  var world = {
    'type': 'Polygon',
    'coordinates': [geoPoints.map((e) => [e.latitude, e.longitude]).toList()]
  };
  final geoJSONPolygon = GeoJSONPolygon.fromMap(world);
  double areaInSquareCentimeters = geoJSONPolygon.area;
  double areaInHectares = areaInSquareCentimeters / 100000000.0;
  return double.parse(areaInHectares.toStringAsFixed(1));
}

  /// Returns a camera position that is good for the current polygon.
CameraPosition getGoodCameraPositionForPolygon(List<GeoPoint> geoPoints) {
  if (geoPoints.isEmpty) {
    return const CameraPosition(
      target: LatLng(0, 0),
      zoom: 0,
    );
  }

  double minLat = geoPoints[0].latitude;
  double maxLat = geoPoints[0].latitude;
  double minLong = geoPoints[0].longitude;
  double maxLong = geoPoints[0].longitude;

  for (var geoPoint in geoPoints) {
    minLat = min(minLat, geoPoint.latitude);
    maxLat = max(maxLat, geoPoint.latitude);
    minLong = min(minLong, geoPoint.longitude);
    maxLong = max(maxLong, geoPoint.longitude);
  }

  // The zoom level is calculated using this formula
  var zoom = log(360 / (maxLong - minLong)) / log(2)*0.95;

  return CameraPosition(
    target: LatLng((minLat + maxLat) / 2, (minLong + maxLong) / 2),
    zoom: zoom,
  );
}
