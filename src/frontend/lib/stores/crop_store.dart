import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/crop_model.dart';

/// Handles CRUD operations for the 'crops' collection in Firestore
class CropStore {

  /// Creates collection in Firestore
  final CollectionReference cropsCollection = FirebaseFirestore.instance.collection('crops');


  List<CropModel> _cropListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CropModel(
        cropId: doc.id,
        name: doc.get('name') ?? '',
        type: doc.get('type') ?? '',);
    }).toList();
  }

  /// Fetches crops stream from Firestore
  Stream<List<CropModel>> get crops {
    return cropsCollection.snapshots().map(_cropListFromSnapshot);
  }
}
