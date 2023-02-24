import 'dart:ffi';

/// Represents a field (set of geopoints) owned by some user
class FieldModel {

  final String fieldId;
  final String fieldName;
  final double area;

  FieldModel({required this.fieldId, required this.fieldName, required this.area});

}