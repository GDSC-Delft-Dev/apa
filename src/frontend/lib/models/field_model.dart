
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Represents a field (set of geopoints) owned by some user
class FieldModel {

  // TODO: add cropId
  final String fieldId;
  final String fieldName;
  final double area;
  final List<GeoPoint> boundaries;
  bool hasInsights;

  FieldModel({
    required this.fieldId,
    required this.fieldName,
    required this.area,
    required this.boundaries,
    this.hasInsights = false });

  setHasInsights(bool hasInsights) {
    this.hasInsights = hasInsights;
  }

}