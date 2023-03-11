
import 'package:cloud_firestore/cloud_firestore.dart';

enum InsightType {disease, pest, nutrient}

/// Represents an insight that has been detected by the image processing pipeline
class InsightModel {

  final String insightId;
  final String fieldId;
  final InsightType type;
  final String name;
  String properName;
  final GeoPoint center;
  final Timestamp date;
  String details;
  String image;
  List<String> recommendations;
  double area;

  InsightModel({
    required this.insightId,
    required this.type,
    required this.name,
    required this.center,
    required this.fieldId,
    required this.date,
    required this.details,
    required this.image,
    required this.properName,
    required this.recommendations,
    required this.area
  });

  String get getInsightId => insightId;

  InsightType get getType => type;

  String get getTypeString => type.toString().split('.').last;

  String get getName => name;

  String get getProperName => properName;

  double get getArea => area;

  GeoPoint get getCenter => center;

  String get getFieldId => fieldId;

  String get getDate {
    return date.toDate().toString().split(' ').first;
  }

  String get getDetails => details;

  String get getImage => image;

  List<String> get getRecommendations => recommendations;

  void setArea(double area) {
    this.area = area;
  }

  void setDetails(String details) {
    this.details = details;
  }

  void setImage(String image) {
    this.image = image;
  }

  void setRecommendations(List<String> recommendations) {
    this.recommendations = recommendations;
  }

  void setProperName (String properName) {
    this.properName = properName;
  }

}