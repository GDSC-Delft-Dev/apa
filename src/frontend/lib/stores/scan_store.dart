import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/insight_model.dart';
import 'package:frontend/models/scan_model.dart';

/// Handles CRUD operations for the 'scanns' collection in Firestore
class ScanStore {
  /// Creates collection in Firestore
  final CollectionReference scansCollection = FirebaseFirestore.instance.collection('scans');

  /// Return scan details
  Future<ScanModel> getScanDetails(String scanId) async {
    return await scansCollection.doc(scanId).get().then(_scanModelFromSnapshot);
  }

  /// Returns scan details for a list of scan IDs
  Future<List<ScanModel>> getScanDetailsList(List<String> scanIds) async {
    List<ScanModel> scans = [];
    for (var scanId in scanIds) {
      scans.add(await getScanDetails(scanId));
    }
    // We sort them based on start date. This is useful for the scan history feature.
    scans.sort(
      (a, b) => a.endDate.compareTo(b.endDate),
    );
    return scans;
  }

  /// Returns scan data from Firestore document
  ScanModel _scanModelFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) {
      throw Exception('Scan not found');
    }
    var data = snapshot.data() as Map<String, dynamic>;

    if (snapshot['result'] == null ||
        Result.values.map((e) => e.name).contains(data['result'].toString().toLowerCase()) ==
            false) {
      throw Exception('Scan result not found');
    }


    List<InsightModel> insights = [];
    for (var insight in snapshot['insights']) {
      insights.add(InsightModel.fromMap(insight));
    }

    return ScanModel(
      scanId: snapshot.id,
      startDate: data['start'].toDate(),
      endDate: data['end'].toDate(),
      result: Result.values
          .firstWhere((element) => element.name == data['result'].toString().toLowerCase()),
      drone: data['drone'] ?? "",
      insights: insights,
      // Pipelines are a reference to the pipeline document in Firestore
      // TODO: Add pipelines to scan model
      pipelines: <String>[],
      indices: data['indicies'] ?? [],
    );
  }
}
