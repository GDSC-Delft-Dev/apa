import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Handles CRUD operations for the 'fields' collection in Firestore
class FieldsStore {

  // the farmer uid that this fields collection corresponds to
  final String uid;

  FieldsStore({required this.uid});

  /// Creates collection in Firestore
  final CollectionReference fieldsCollection = FirebaseFirestore.instance.collection('fields');

  /// Updates attribute values for an instance in the 'fields' collection
  Future updateFieldData(String uid, String name, Float area) async {
    return await fieldsCollection.doc(uid).set({
      'field_name': name,
      'area': area
      // TODO: add boundaries (list[Geopoint])
      // TODO: add crops (list[Crop])
      // TODO: add runs (list[Runs])
    });
  }

  /// Fetches fields stream from Firestore
  Stream<QuerySnapshot> get fields {
    return fieldsCollection.snapshots();
  }

}