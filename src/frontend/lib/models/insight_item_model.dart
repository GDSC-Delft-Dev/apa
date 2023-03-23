import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_logs/model/flog/flog.dart';

/// Represents an insight that has been detected by the image processing pipeline
/// This is a base class that is extended by other insight models
class InsightItemModel {
  final String id;
  final String name;
  final String description;

  InsightItemModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory InsightItemModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    FLog.info(
        className: "InsightItemModel",
        methodName: "fromDocumentSnapshot",
        text: "Converting insight item with data: ${snapshot.data()}");
    var data = snapshot.data() as Map<String, dynamic>;

    return InsightItemModel(
      id: snapshot.id,
      name: data['name'],
      description: data['description'],
    );
  }

  factory InsightItemModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    return InsightItemModel(
      id: snapshot.id,
      name: snapshot['name'],
      description: snapshot['description'],
    );
  }

  factory InsightItemModel.fromMap(Map<String, dynamic> map) {
    return InsightItemModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'InsightItemModel{name: $name, description: $description}';
  }
}
