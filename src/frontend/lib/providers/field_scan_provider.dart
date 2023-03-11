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
    _fieldScans = [];
    ScanStore().getScanDetailsList(scanIds).then((scans) {
      _fieldScans = scans;
      if (_fieldScans.isNotEmpty) {
        _selectedFieldScan = _fieldScans.last;
      } else {
        _selectedFieldScan = null;
      }
      notifyListeners();
    }).onError((error, stackTrace) {
      print("Error occured while fetching field scans: " + error.toString());
      notifyListeners();
    });
  }

  /// Sets the selected field to the one previous to the current one.
  /// If the current selected field is the first one, then nothing happens.
  /// If there are no field scans, then nothing happens.
  void selectPreviousFieldScan() {
    if (_fieldScans.isEmpty) {
      return;
    }
    if (_selectedFieldScan == _fieldScans.first) {
      return;
    }
    _selectedFieldScan = _fieldScans[_fieldScans.indexOf(_selectedFieldScan!) - 1];
    notifyListeners();
  }

  /// Sets the selected field to the one next to the current one.
  /// If the current selected field is the last one, then nothing happens.
  /// If there are no field scans, then nothing happens.
  void selectNextFieldScan() {
    if (_fieldScans.isEmpty) {
      return;
    }
    if (_selectedFieldScan == _fieldScans.last) {
      return;
    }
    _selectedFieldScan = _fieldScans[_fieldScans.indexOf(_selectedFieldScan!) + 1];
    notifyListeners();
  }

  /// Returns if the selected field scan is the first one.
  /// If there are no field scans, then false is returned.
  bool isFirstFieldScan() {
    if (_fieldScans.isEmpty) {
      return false;
    }
    return _selectedFieldScan == _fieldScans.first;
  }

  /// Returns if the selected field scan is the last one.
  /// If there are no field scans, then false is returned.
  bool isLastFieldScan() {
    if (_fieldScans.isEmpty) {
      return false;
    }
    return _selectedFieldScan == _fieldScans.last;
  }
}
