import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/perpetrator_model.dart';

import 'insights_type_store.dart';

class PerpetratorStore {
  PerpetratorStore();

  final CollectionReference pestsCollection = FirebaseFirestore.instance.collection('pests');

  final CollectionReference diseasesCollection = FirebaseFirestore.instance.collection('diseases');

  List<PerpetratorModel> _perpetratorListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => PerpetratorModel.fromQueryDocumentSnapshot(doc)).toList();
  }

  Stream<List<PerpetratorModel>> get pests {
    return pestsCollection.snapshots().map(_perpetratorListFromSnapshot);
  }

  Stream<List<PerpetratorModel>> get diseases {
    return diseasesCollection.snapshots().map(_perpetratorListFromSnapshot);
  }

  PerpetratorModel _perpetratorModelFromSnapshot(DocumentSnapshot snapshot) {
    return PerpetratorModel.fromDocumentSnapshot(snapshot);
  }

  Future<PerpetratorModel> getPerpetratorById(String perpetratorId, String insightTypeId) async {
    var insightType = await InsightsTypeStore().getInsightTypeById(insightTypeId);
    if (insightType.name == 'disease') {
      return await diseasesCollection.doc(perpetratorId).get().then(_perpetratorModelFromSnapshot);
    } else {
      return await pestsCollection.doc(perpetratorId).get().then(_perpetratorModelFromSnapshot);
    }
  }
}
