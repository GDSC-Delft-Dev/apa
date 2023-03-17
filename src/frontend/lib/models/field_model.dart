import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'insight_model.dart';

/// Represents a field (set of geopoints) owned by some user
class FieldModel {
  final String fieldId;
  final String fieldName;
  final double area;
  final String cropId;
  final List<GeoPoint> boundaries;
  final List<String> scans;
  bool hasInsights;

  FieldModel(
      {required this.fieldId,
      required this.fieldName,
      required this.area,
      required this.boundaries,
      required this.cropId,
      required this.scans,
      this.hasInsights = false});

  setHasInsights(bool hasInsights) {
    this.hasInsights = hasInsights;
  }
}
