import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/perpetrator_model.dart';


/// This class represents a pest item.
class PestModel extends PerpetratorModel {
  PestModel({
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


  factory PestModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return PestModel(
      id: snapshot.id,
      name: snapshot['name'],
      description: snapshot['description'],
      properName: snapshot['proper_name'],
      alternativeNames: List<String>.from(snapshot['alternative_names']),
      referenceImage: snapshot['reference_image'],
      category: snapshot['category'],
    );
  }

  factory PestModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    return PestModel(
      id: snapshot.id,
      name: snapshot['name'],
      description: snapshot['description'],
      properName: snapshot['proper_name'],
      alternativeNames: List<String>.from(snapshot['alternative_names']),
      referenceImage: snapshot['reference_image'],
      category: snapshot['category'],
    );
  }

  factory PestModel.fromMap(Map<String, dynamic> map) {
    return PestModel(
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
    return 'PestModel{id: $id, name: $name, description: $description, properName: $properName, alternativeNames: $alternativeNames, referenceImage: $referenceImage, category: $category}';
  }
}
