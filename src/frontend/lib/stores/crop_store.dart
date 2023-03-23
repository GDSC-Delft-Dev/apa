import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/crop_model.dart';

/// Handles CRUD operations for the 'crops' collection in Firestore
class CropStore {
  /// Creates collection in Firestore
  final CollectionReference cropsCollection = FirebaseFirestore.instance.collection('crops');

  List<CropModel> _cropListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      print(doc.id);
      var data = doc.data() as Map<String, dynamic>;
      return CropModel(
        cropId: doc.id,
        name: data.containsKey('name') ? data['name'] : 'corn',
        type: data.containsKey('type') ? data['type'] : '',
      );
    }).toList();
  }

  /// Fetches crops stream from Firestore
  Stream<List<CropModel>> get crops {
    print("getting crops");
    return cropsCollection.snapshots().map(_cropListFromSnapshot);
  }
}
