
import 'package:cloud_firestore/cloud_firestore.dart';

enum InsightType {disease, pest, nutrient}


class InsightModel {

  final String insightId;
  final InsightType type;
  final String details;
  final GeoPoint center;
  final String fieldId;
  final Timestamp date;

  InsightModel({
    required this.insightId,
    required this.type,
    required this.details,
    required this.center,
    required this.fieldId,
    required this.date
  });


}