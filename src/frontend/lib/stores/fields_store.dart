import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/field_model.dart';

/// Handles CRUD operations for the 'fields' collection in Firestore
class FieldsStore {

  /// User that is logged in
  final String userId;

  FieldsStore({ required this.userId });

  /// Creates collection in Firestore
  final CollectionReference fieldsCollection = FirebaseFirestore.instance.collection('fields');


  /// Returns field data from Firestore document
  FieldModel _fieldModelFromSnapshot(DocumentSnapshot snapshot) {
    return FieldModel(
        fieldId: snapshot.id,
        fieldName: snapshot['field_name'],
        area: snapshot['area'],
        hasInsights: snapshot['has_insights']);
  }

  /// Updates attribute values for an instance in the 'fields' collection
  Future updateFieldData(String fieldId, String name, double area, bool hasInsights) async {
    return await fieldsCollection.doc(fieldId).set({
      'field_name': name,
      'area': area,
      'has_insights': hasInsights
    });
  }

  Future addNewField(String name, double area) async {
    var addFieldData = Map<String, dynamic>();
    addFieldData['field_name'] = name;
    addFieldData['area'] = area;
    addFieldData['user_id'] = userId;
    addFieldData['has_insights'] = false; // by default, a field has no insights yet
    return fieldsCollection.doc().set(addFieldData);
  }

  List <FieldModel> _fieldListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return FieldModel(
          fieldId: doc.id,
          fieldName: doc.get('field_name') ?? '',
          area: doc.get('area') ?? 0,
          hasInsights: doc.get('has_insights') ?? false
      );
    }).toList();
  }

  /// Fetches fields stream from Firestore
  Stream<List<FieldModel>> get fields {
    return fieldsCollection
    .where('user_id', isEqualTo: userId).snapshots()
    .map(_fieldListFromSnapshot);
  }

}