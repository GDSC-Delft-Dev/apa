import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/field_model.dart';

/// Handles CRUD operations for the 'fields' collection in Firestore
class FieldsStore {

  // the farmer uid that this fields collection corresponds to
  // TODO: add field uid?
  final String uid;

  FieldsStore({required this.uid});

  /// Creates collection in Firestore
  final CollectionReference fieldsCollection = FirebaseFirestore.instance.collection('fields');

  /// Updates attribute values for an instance in the 'fields' collection
  Future updateFieldData(String name, double area) async {
    return await fieldsCollection.doc(uid).set({
      'field_name': name,
      'area': area
      // TODO: add boundaries (list[Geopoint])
      // TODO: add crops (list[Crop])
      // TODO: add runs (list[Runs])
    });
  }

  List <FieldModel> _fieldListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return FieldModel(
          fieldName: doc.get('field_name') ?? '',
          area: doc.get('area') ?? 0
      );
    }).toList();
  }

  /// Fetches fields stream from Firestore
  Stream<List<FieldModel>> get fields {
    return fieldsCollection.snapshots()
    .map(_fieldListFromSnapshot);
  }

}