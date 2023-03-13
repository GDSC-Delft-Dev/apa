import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/insight_type_model.dart';

/// Provides a list of all the [InsightType]s taken from firebase.
class InsightTypesProvider extends ChangeNotifier {
  List<InsightTypeModel> _insightTypes = [];
  List<InsightTypeModel> get insightTypes => _insightTypes;

  // Firebase collection reference
  final CollectionReference insightsTypeCollection =
      FirebaseFirestore.instance.collection('insights_types');

  /// Fetches insights types from firebase and stores them in [_insightTypes].
  Future<void> fetchInsightTypes() async {
    try {
      final QuerySnapshot snapshot = await insightsTypeCollection.get();
      _insightTypes = snapshot.docs.map(InsightTypeModel.fromQueryDocumentSnapshot).toList();
      notifyListeners();
    } catch (e) {
      print("Error occured while fetching insight types: " + e.toString());
    }
  }

  /// Returns the [InsightTypeModel] with the given [id].
  InsightTypeModel getInsightTypeById(String id) {
    return _insightTypes.firstWhere((insightType) => insightType.id == id);
  }
}
