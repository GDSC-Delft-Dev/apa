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

// Get center of a polygon
LatLng getCenterOfPolygon(List<LatLng> points) {
  double x = 0;
  double y = 0;
  double z = 0;

  for (var point in points) {
    double latitude = point.latitude * pi / 180;
    double longitude = point.longitude * pi / 180;

    x += cos(latitude) * cos(longitude);
    y += cos(latitude) * sin(longitude);
    z += sin(latitude);
  }

  int total = points.length;

  x = x / total;
  y = y / total;
  z = z / total;

  double centralLongitude = atan2(y, x);
  double centralSquareRoot = sqrt(x * x + y * y);
  double centralLatitude = atan2(z, centralSquareRoot);
  
  return LatLng(centralLatitude * 180 / pi, centralLongitude * 180 / pi);
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

// Returns an LatLngBounds object that encloses the polygon
// This is used to set the image overlay boundaries.
LatLngBounds getLatLngBoundsForPolygon(List<GeoPoint> geoPoints) {
  if (geoPoints.isEmpty) {
    return LatLngBounds(
      southwest: const LatLng(0, 0),
      northeast: const LatLng(0, 0),
    );
  }

  // TODO: It should account for the case where the polygon crosses the 180th meridian
  // and the longitude values are negative.
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

  return LatLngBounds(
    southwest: LatLng(minLat, minLong),
    northeast: LatLng(maxLat, maxLong),
  );
}
