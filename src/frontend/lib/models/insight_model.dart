import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an insight that has been detected by the image processing pipeline
class InsightModel {
  final String typeId;
  final GeoPoint center;
  final Map<String, dynamic> data;

  InsightModel({
    required this.typeId,
    required this.center,
    required this.data,
  });

  factory InsightModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return InsightModel(
      typeId: snapshot['typeId'],
      center: snapshot['center'],
      data: snapshot['data'],
    );
  }

  factory InsightModel.fromMap(Map<String, dynamic> map) {
    return InsightModel(
      typeId: map['typeId'],
      center: map['center'],
      data: map['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'typeId': typeId,
      'center': center,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'InsightModel{typeId: $typeId, center: $center, data: $data}';
  }
}
