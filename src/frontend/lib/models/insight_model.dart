
import 'package:cloud_firestore/cloud_firestore.dart';

enum InsightType {disease, pest, nutrient}

/// Represents an insight that has been detected by the image processing pipeline
class InsightModel {

  final String insightId;
  final InsightType type;
  final String details;
  final GeoPoint center;
  final String fieldId;
  final Timestamp date;
  final String characteristics;
  final String image;
  final List<String> recommendations;

  InsightModel({
    required this.insightId,
    required this.type,
    required this.details,
    required this.center,
    required this.fieldId,
    required this.date,
    required this.characteristics,
    required this.image,
    required this.recommendations
  });

  String get getInsightId => insightId;

  InsightType get getType => type;

  String get getTypeString => type.toString().split('.').last;

  String get getDetails => details;

  GeoPoint get getCenter => center;

  String get getFieldId => fieldId;

  Timestamp get getDate => date;

  String get getCharacteristics => characteristics;

  String get getImage => image;

  List<String> get getRecommendations => recommendations;

}