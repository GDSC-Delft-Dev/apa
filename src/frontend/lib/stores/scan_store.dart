import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/insight_model.dart';
import 'package:frontend/models/scan_model.dart';

/// Handles CRUD operations for the 'scanns' collection in Firestore
class ScanStore {
  /// Creates collection in Firestore
  final CollectionReference scansCollection = FirebaseFirestore.instance.collection('scans');

  /// Return scan details
  Future<ScanModel> getScanDetails(String scanId) async {
    print(scanId);
    return await scansCollection.doc(scanId).get().then(_scanModelFromSnapshot);
  }

  /// Returns scan details for a list of scan IDs
  Future<List<ScanModel>> getScanDetailsList(List<String> scanIds) async {
    List<ScanModel> scans = [];
    for (var scanId in scanIds) {
      scans.add(await getScanDetails(scanId));
    }
    print(scans);

    // We sort them based on start date. This is useful for the scan history feature.
    scans.sort(
      (a, b) => a.startDate.compareTo(b.startDate),
    );

    return scans;
  }

  /// Returns scan data from Firestore document
  ScanModel _scanModelFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) {
      throw Exception('Scan not found');
    }

    if (snapshot['result'] == null ||
        Result.values.map((e) => e.name).contains(snapshot['result'].toString().toLowerCase()) ==
            false) {
      throw Exception('Scan result not found');
    }

    return ScanModel(
      scanId: snapshot.id,
      startDate: snapshot['start'].toDate(),
      endDate: snapshot['end'].toDate(),
      result: Result.values
          .firstWhere((element) => element.name == snapshot['result'].toString().toLowerCase()),
      drone: snapshot['drone'],
      insights: snapshot['insights'].map((x) => InsightModel.fromMap(x)) ?? [],
      // Pipelines are a reference to the pipeline document in Firestore
      pipelines: [],
      indices: snapshot['indices'] ?? [],
    );
  }
}
