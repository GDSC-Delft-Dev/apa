// A class that represents either a Pest or a Disease.
import 'package:cloud_firestore/cloud_firestore.dart';

class PerpetratorModel {
  final String id;
  final String name;
  final String properName;
  final List<String> alternativeNames;
  final String referenceImage;
  final String description;
  final String category;

  PerpetratorModel({
    required this.id,
    required this.name,
    required this.properName,
    required this.alternativeNames,
    required this.referenceImage,
    required this.description,
    required this.category,
  });

  factory PerpetratorModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return PerpetratorModel(
      id: snapshot.id,
      name: snapshot['name'],
      properName: snapshot['properName'],
      alternativeNames: (snapshot['alternativeNames'] as List<dynamic>).map((e) => e.toString()).toList(),
      referenceImage: snapshot['referenceImage'],
      description: snapshot['description'],
      category: snapshot['category'],
    );
  }

  factory PerpetratorModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    return PerpetratorModel(
      id: snapshot.id,
      name: snapshot['name'],
      properName: snapshot['properName'],
      alternativeNames: (snapshot['alternativeNames'] as List<dynamic>).map((e) => e.toString()).toList(),
      referenceImage: snapshot['referenceImage'],
      description: snapshot['description'],
      category: snapshot['category'],
    );
  }

  factory PerpetratorModel.fromMap(Map<String, dynamic> map) {
    return PerpetratorModel(
      id: map['id'],
      name: map['name'],
      properName: map['properName'],
      alternativeNames: map['alternativeNames'],
      referenceImage: map['referenceImage'],
      description: map['description'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'properName': properName,
      'alternativeNames': alternativeNames,
      'referenceImage': referenceImage,
      'description': description,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Perpetrator{id: $id, name: $name, properName: $properName, alternativeNames: $alternativeNames, referenceImage: $referenceImage, description: $description, category: $category}';
  }
}
