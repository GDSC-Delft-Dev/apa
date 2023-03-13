import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/perpetrator_model.dart';

/// This class represents a disease item.
class DiseaseModel extends PerpetratorModel {
  DiseaseModel({
    required String id,
    required String name,
    required String description,
    required String properName,
    required List<String> alternativeNames,
    required String referenceImage,
    required String category,
  }) : super(
          id: id,
          name: name,
          description: description,
          properName: properName,
          alternativeNames: alternativeNames,
          referenceImage: referenceImage,
          category: category,
        );
  
  factory DiseaseModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return DiseaseModel(
      id: snapshot.id,
      name: snapshot['name'],
      description: snapshot['description'],
      properName: snapshot['proper_name'],
      alternativeNames: List<String>.from(snapshot['alternative_names']),
      referenceImage: snapshot['reference_image'],
      category: snapshot['category'],
    );
  }

  factory DiseaseModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    return DiseaseModel(
      id: snapshot.id,
      name: snapshot['name'],
      description: snapshot['description'],
      properName: snapshot['proper_name'],
      alternativeNames: List<String>.from(snapshot['alternative_names']),
      referenceImage: snapshot['reference_image'],
      category: snapshot['category'],
    );
  }

  factory DiseaseModel.fromMap(Map<String, dynamic> map) {
    return DiseaseModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      properName: map['properName'],
      alternativeNames: List<String>.from(map['alternativeNames']),
      referenceImage: map['referenceImage'],
      category: map['category'],
    );
  }

  @override
  String toString() {
    return 'DiseaseModel{id: $id, name: $name, description: $description, properName: $properName, alternativeNames: $alternativeNames, referenceImage: $referenceImage, category: $category}';
  }
}
