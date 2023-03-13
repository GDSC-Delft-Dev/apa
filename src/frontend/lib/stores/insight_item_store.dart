import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/disease_model.dart';
import 'package:frontend/models/insight_item_model.dart';
import 'package:frontend/models/perpetrator_model.dart';
import 'package:frontend/models/pest_model.dart';

import 'insights_type_store.dart';

class InsightItemStore {
  InsightItemStore();

  final Map<String, String> _insightTypeToFirebaseCollection = {
    'pest': 'pests',
    'disease': 'diseases',
  };

  final Map<String, Function> _insightItemModelFromSnapshotMap = {
    'pests': (DocumentSnapshot snapshot) => PestModel.fromDocumentSnapshot(snapshot),
    'diseases': (DocumentSnapshot snapshot) => DiseaseModel.fromDocumentSnapshot(snapshot),
    'default': (DocumentSnapshot snapshot) => InsightItemModel.fromDocumentSnapshot(snapshot),
  };

  Future<InsightItemModel> getInsightItemById(String insightItemId, String insightTypeId) async {
    print("Hello there: " + insightTypeId);
    var insightType = await InsightsTypeStore().getInsightTypeById(insightTypeId);
    var name = _insightTypeToFirebaseCollection[insightType.name] ?? 'default';
    var doc = FirebaseFirestore.instance.collection(name).doc(insightItemId).get();
    return await doc.then((x) => _insightItemModelFromSnapshotMap[name]!(x));
  }
}
