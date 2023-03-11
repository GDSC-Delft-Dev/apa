
import 'package:flutter/material.dart';
import 'package:frontend/models/scan_model.dart';

/// This class is used to store the selected field scan for a field.
class FieldScanProvider extends ChangeNotifier {

  /// The id of the selected field scan.
  String? _selectedFieldScanId;

  String? get selectedFieldScanId => _selectedFieldScanId;

  ScanModel? _selectedFieldScan;
  ScanModel? get selectedFieldScan => _selectedFieldScan;

  void setSelectedFieldScanId(String? selectedFieldScanId) {
    _selectedFieldScanId = selectedFieldScanId;
    notifyListeners();
  }

  void setSelectedFieldScan(ScanModel selectedFieldScan) {
    _selectedFieldScan = selectedFieldScan;
    notifyListeners();
  }
}
