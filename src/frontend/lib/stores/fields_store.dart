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
  /// TODO: add crop_id
  FieldModel _fieldModelFromSnapshot(DocumentSnapshot snapshot) {
    return FieldModel(
        fieldId: snapshot.id,
        fieldName: snapshot['field_name'],
        area: snapshot['area'],
        // Convert Firebase array of GeoPoints into List<GeoPoint>
        boundaries: List<GeoPoint>.from(snapshot['boundaries']?.map((loc) => GeoPoint(loc.latitude, loc.longitude)) ?? []),
        hasInsights: snapshot['has_insights']);
  }

  Future<FieldModel> getFieldById(String fieldId) async {
    return await fieldsCollection
    .doc(fieldId)
    .get().then(_fieldModelFromSnapshot);
  }

  /// Updates attribute values for an instance in the 'fields' collection
  Future updateFieldData(String fieldId, String name, double area, bool hasInsights) async {
    return await fieldsCollection.doc(fieldId).set({
      'field_name': name,
      'area': area,
      'has_insights': hasInsights
    });
  }

  Future addNewField(String name, double area, List<GeoPoint> boundaries) async {
    var addFieldData = Map<String, dynamic>();
    addFieldData['field_name'] = name;
    addFieldData['area'] = area;
    addFieldData['user_id'] = userId;
    addFieldData['boundaries'] =  boundaries;
    addFieldData['has_insights'] = false; // by default, a field has no insights yet
    // TODO: add crop_id
    return fieldsCollection.doc().set(addFieldData);
  }

  List <FieldModel> _fieldListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){

      List<dynamic> boundariesList = doc.get('boundaries');
      List<GeoPoint> boundaries = [];

      if (boundariesList != null && boundariesList is List) {
        boundaries = boundariesList
            .map((loc) => GeoPoint(loc.latitude, loc.longitude))
            .toList();
      }

      return FieldModel(
          fieldId: doc.id,
          fieldName: doc.get('field_name') ?? '',
          area: doc.get('area') ?? 0,
          // Convert Firebase array of GeoPoints into List<GeoPoint>
          boundaries: boundaries,
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