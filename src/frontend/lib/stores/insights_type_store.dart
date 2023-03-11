import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/insight_type_model.dart';
import '../models/insight_model.dart';
import '../utils/insights_utils.dart' as utils;

class InsightsTypeStore {
  InsightsTypeStore();

  final CollectionReference insightsTypeCollection =
      FirebaseFirestore.instance.collection('insights_types');

  InsightTypeModel _insightTypeModelFromSnapshot(DocumentSnapshot snapshot) {
    return InsightTypeModel(
      id: snapshot.id,
      name: snapshot['name'].toString(),
      icon: snapshot['icon'].toString(),
    );
  }

  Future<InsightTypeModel> getInsightTypeById(String insightTypeId) async {
    return await insightsTypeCollection
        .doc(insightTypeId)
        .get()
        .then(_insightTypeModelFromSnapshot);
  }

  Future<List<InsightTypeModel>> getInsightTypesByIds(List<String> insightTypeIds) async {
    List<InsightTypeModel> insightTypes = [];
    for (var insightTypeId in insightTypeIds) {
      insightTypes.add(await getInsightTypeById(insightTypeId));
    }
    return insightTypes;
  }

  List<InsightTypeModel> _insightTypeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return InsightTypeModel(
        id: doc.id,
        name: doc.get('name'),
        icon: doc.get('icon'),
      );
    }).toList();
  }

  Stream<List<InsightTypeModel>> get insightTypes {
    return insightsTypeCollection.snapshots().map(_insightTypeListFromSnapshot);
  }
}
