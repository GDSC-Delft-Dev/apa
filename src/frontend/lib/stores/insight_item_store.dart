import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:frontend/models/disease_model.dart';
import 'package:frontend/models/insight_item_model.dart';
import 'package:frontend/models/perpetrator_model.dart';
import 'package:frontend/models/pest_model.dart';

import 'insights_type_store.dart';

class InsightItemStore {
  InsightItemStore();

  Future<InsightItemModel> getInsightItemByTypeId(
      Map<String, dynamic> insightData, String insightTypeId) async {
    FLog.info(
        className: "InsightItemStore",
        methodName: "getInsightItemByTypeId",
        text: "Getting insight item by type id");

    var insightType = await InsightsTypeStore().getInsightTypeById(insightTypeId);
    FLog.info(
        className: "InsightItemStore",
        methodName: "getInsightItemByTypeId",
        text: "Got insight type with name: ${insightType.name}");
    // Insight item will be a document reference: e.g. 'pest' or 'disease
    var insightItem = insightData[insightType.name.toLowerCase()];
    FLog.info(
        className: "InsightItemStore",
        methodName: "getInsightItemByTypeId",
        text: "Insight item is ${insightItem.runtimeType}");
    var doc = await insightItem.get();

    FLog.info(
        className: "InsightItemStore",
        methodName: "getInsightItemByTypeId",
        text: "Got insight item by type id ${doc.id}");

    return InsightItemModel.fromDocumentSnapshot(doc);
  }
}
