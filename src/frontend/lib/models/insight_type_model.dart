import 'package:cloud_firestore/cloud_firestore.dart';

class InsightTypeModel {
  final String id;
  final String name;
  final List<String> recommendations;
  final String icon;

  InsightTypeModel({
    required this.id,
    required this.name,
    required this.recommendations,
    required this.icon,
  });

  factory InsightTypeModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return InsightTypeModel(
      id: snapshot.id,
      name: snapshot['name'],
      recommendations: snapshot['recommendations'],
      icon: snapshot['icon'],
    );
  }

  factory InsightTypeModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    return InsightTypeModel(
      id: snapshot.id,
      name: snapshot['name'],
      recommendations: (snapshot['recommendations'] as List<dynamic>).map((e) => e.toString()).toList(),
      icon: snapshot['icon'],
    );
  }

  factory InsightTypeModel.fromMap(Map<String, dynamic> map) {
    return InsightTypeModel(
      id: map['id'],
      name: map['name'],
      recommendations: map['recommendations'],
      icon: map['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'recommendations': recommendations,
      'icon': icon,
    };
  }

  @override
  String toString() {
    return 'InsightTypeModel{id: $id, name: $name, recommendations: $recommendations, icon: $icon}';
  }
}
