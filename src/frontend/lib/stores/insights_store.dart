import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/insight_model.dart';
import '../utils/insights_utils.dart' as utils;

class InsightsStore {

  InsightsStore();

  final CollectionReference insightsCollection = FirebaseFirestore.instance.collection('insights');

  InsightModel _insightModelFromSnapshot(DocumentSnapshot snapshot) {
    return InsightModel(
        insightId: snapshot.id,
        type: InsightType.values[snapshot['type']],
        details: snapshot['details'],
        center: snapshot['center'],
        fieldId: snapshot['field_id'],
        date: snapshot['date']);
  }

  Future<InsightModel> getInsightById(String insightId) async {
    return await insightsCollection
        .doc(insightId)
        .get()
        .then(_insightModelFromSnapshot);
  }

  Future addNewInsight(InsightType type, String details, GeoPoint center, String fieldId) async {
    var addInsightData = Map<String, dynamic>();
    addInsightData['type'] = type.index;
    addInsightData['details'] = details;
    addInsightData['center'] = center;
    addInsightData['field_id'] = fieldId;
    addInsightData['date'] = Timestamp.now();
    return insightsCollection.doc().set(addInsightData);
  }

  List<InsightModel> _insightListFromSnapshot(QuerySnapshot snapshot){

    return snapshot.docs.map((doc){
      return InsightModel(
          insightId: doc.id,
          type: utils.enumFromString(doc.get('type'), InsightType.values),
          details: doc.get('details'),
          center: doc.get('center'),
          fieldId: doc.get('field_id'),
          date: doc.get('date'));
    }).toList();
  }

  Stream<List<InsightModel>> get insights {
    return insightsCollection.snapshots().map(_insightListFromSnapshot);
  }

  Stream<List<InsightModel>> getInsightsByFieldId(String fieldId) {
    return insightsCollection.where('field_id', isEqualTo: fieldId)
      .snapshots()
      .map(_insightListFromSnapshot);
  }

  Future deleteInsight(String insightId) async {
    return await insightsCollection.doc(insightId).delete();
  }

  Future updateInsightData(String insightId, InsightType type, String details, GeoPoint center, String fieldId) async {
    return await insightsCollection.doc(insightId).set({
      'type': type.index,
      'details': details,
      'center': center,
      'field_id': fieldId,
      'date': Timestamp.now()
    });
  }

}