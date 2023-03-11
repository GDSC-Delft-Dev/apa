import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/scan_model.dart';
import 'package:frontend/stores/scan_store.dart';

/// This class is used to store the selected field scan for a field and all available ones.
class FieldScanProvider extends ChangeNotifier {
  ScanModel? _selectedFieldScan;
  ScanModel? get selectedFieldScan => _selectedFieldScan;

  List<ScanModel> _fieldScans = [];
  List<ScanModel> get fieldScans => _fieldScans;

  /// Sets the selected field scan to [selectedFieldScan].
  void setSelectedFieldScan(ScanModel selectedFieldScan) {
    _selectedFieldScan = selectedFieldScan;
    notifyListeners();
  }

  /// Fetches field scans from firebase and stores them in [_fieldScans].
  Future<void> fetchFieldScans(List<String> scanIds) async {
    ScanStore().getScanDetailsList(scanIds).then((scans) {
      _fieldScans = scans;
      if (_fieldScans.isNotEmpty) {
        _selectedFieldScan = _fieldScans.last;
      }
      notifyListeners();
    });
  }
}
