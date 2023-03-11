// A class that represents either a Pest or a Disease.
import 'package:cloud_firestore/cloud_firestore.dart';

import 'insight_item_model.dart';

class PerpetratorModel extends InsightItemModel {
  final String properName;
  final List<String> alternativeNames;
  final String referenceImage;
  final String category;

  PerpetratorModel({
    required super.id,
    required super.name,
    required super.description,
    required this.properName,
    required this.alternativeNames,
    required this.referenceImage,
    required this.category,
  });

  factory PerpetratorModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return PerpetratorModel(
      id: snapshot.id,
      name: snapshot['name'],
      description: snapshot['description'],
      properName: snapshot['proper_name'],
      alternativeNames: List<String>.from(snapshot['alternative_names']),
      referenceImage: snapshot['reference_image'],
      category: snapshot['category'],
    );
  }

  factory PerpetratorModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    return PerpetratorModel(
      id: snapshot.id,
      name: snapshot['name'],
      description: snapshot['description'],
      properName: snapshot['proper_name'],
      alternativeNames: List<String>.from(snapshot['alternative_names']),
      referenceImage: snapshot['reference_image'],
      category: snapshot['category'],
    );
  }

  factory PerpetratorModel.fromMap(Map<String, dynamic> map) {
    return PerpetratorModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      properName: map['proper_name'],
      alternativeNames: List<String>.from(map['alternative_names']),
      referenceImage: map['reference_image'],
      category: map['category'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'proper_name': properName,
      'alternative_names': alternativeNames,
      'reference_image': referenceImage,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'PerpetratorModel{id: $id, name: $name, description: $description, properName: $properName, alternativeNames: $alternativeNames, referenceImage: $referenceImage, category: $category}';
  }
}
