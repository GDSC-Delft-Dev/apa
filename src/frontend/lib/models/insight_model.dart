
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an insight that has been detected by the image processing pipeline
class InsightModel {

  final String insightId;
  final String typeId;
  final GeoPoint center;
  final Map<String, dynamic> data;

  InsightModel({
    required this.insightId,
    required this.typeId,
    required this.center,
    required this.data,
  });

  factory InsightModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return InsightModel(
      insightId: snapshot.id,
      typeId: snapshot['typeId'],
      center: snapshot['center'],
      data: snapshot['data'],
    );
  }

  factory InsightModel.fromMap(Map<String, dynamic> map) {
    return InsightModel(
      insightId: map['insightId'],
      typeId: map['typeId'],
      center: map['center'],
      data: map['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'insightId': insightId,
      'typeId': typeId,
      'center': center,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'InsightModel{insightId: $insightId, typeId: $typeId, center: $center, data: $data}';
  }
}