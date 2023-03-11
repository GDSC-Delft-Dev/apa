
import 'package:cloud_firestore/cloud_firestore.dart';

import 'insight_item_model.dart';


/// This class represents a nutrient deficiency item.
class NutrientDeficienciesModel extends InsightItemModel {
  final String properName;
  final String referenceImage;

  NutrientDeficienciesModel({
    required super.id,
    required super.name,
    required super.description,
    required this.properName,
    required this.referenceImage,
  });

  factory NutrientDeficienciesModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return NutrientDeficienciesModel(
      id: snapshot.id,
      name: snapshot['name'],
      description: snapshot['description'],
      properName: snapshot['proper_name'],
      referenceImage: snapshot['reference_image'],
    );
  }

  factory NutrientDeficienciesModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    return NutrientDeficienciesModel(
      id: snapshot.id,
      name: snapshot['name'],
      description: snapshot['description'],
      properName: snapshot['proper_name'],
      referenceImage: snapshot['referenceImage'],
    );
  }

  factory NutrientDeficienciesModel.fromMap(Map<String, dynamic> map) {
    return NutrientDeficienciesModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      properName: map['properName'],
      referenceImage: map['reference_image'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'properName': properName,
      'referenceImage': referenceImage,
    };
  }
}