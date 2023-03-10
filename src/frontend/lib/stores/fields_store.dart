import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/crop_model.dart';
import '../models/field_model.dart';

/// Handles CRUD operations for the 'fields' collection in Firestore
class FieldsStore {
  /// User that is logged in
  final String userId;

  FieldsStore({required this.userId});

  /// Creates collection in Firestore
  final CollectionReference fieldsCollection = FirebaseFirestore.instance.collection('fields');

  /// Returns field data from Firestore document
  FieldModel _fieldModelFromSnapshot(DocumentSnapshot snapshot) {
    return FieldModel(
      fieldId: snapshot.id,
      fieldName: snapshot['field_name'],
      area: snapshot['area'],
      cropId: snapshot['crop_id'],
      // Convert Firebase array of GeoPoints into List<GeoPoint>
      boundaries: List<GeoPoint>.from(
          snapshot['boundaries']?.map((loc) => GeoPoint(loc.latitude, loc.longitude)) ?? []),
      hasInsights: snapshot['has_insights'],
      runs: List<String>.from(snapshot['runs'] ?? []),
    );
  }

  Future<FieldModel> getFieldById(String fieldId) async {
    return await fieldsCollection.doc(fieldId).get().then(_fieldModelFromSnapshot);
  }

  /// Updates attribute values for an instance in the 'fields' collection
  Future updateFieldData(
      String fieldId, String name, CropModel crop, double area, bool hasInsights) async {
    return await fieldsCollection.doc(fieldId).set(
        {'field_name': name, 'area': area, 'has_insights': hasInsights, 'crop_id': crop.cropId});
  }

  Future addNewField(String name, String cropId, double area, List<GeoPoint> boundaries) async {
    var addFieldData = <String, dynamic>{};
    addFieldData['field_name'] = name;
    addFieldData['area'] = area;
    addFieldData['crop_id'] = cropId;
    addFieldData['user_id'] = userId;
    addFieldData['boundaries'] = boundaries;
    addFieldData['has_insights'] = false; // by default, a field has no insights yet
    addFieldData['runs'] = []; // by default, a field has no scans yet
    return fieldsCollection.doc().set(addFieldData);
  }

  List<FieldModel> _fieldListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      List<dynamic>? boundariesList = doc.get('boundaries');
      List<GeoPoint> boundaries = [];

      if (boundariesList != null) {
        boundaries = boundariesList.map((loc) => GeoPoint(loc.latitude, loc.longitude)).toList();
      }

      return FieldModel(
          fieldId: doc.id,
          fieldName: doc.get('field_name') ?? '',
          area: doc.get('area') ?? 0,
          cropId: doc.get('crop_id') ?? '',
          // Convert Firebase array of GeoPoints into List<GeoPoint>
          boundaries: boundaries,
          runs: List<String>.from(doc.get('runs') ?? []),
          hasInsights: doc.get('has_insights') ?? false);
    }).toList();
  }

  /// Fetches fields stream from Firestore
  Stream<List<FieldModel>> get fields {
    return fieldsCollection
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(_fieldListFromSnapshot);
  }
}
