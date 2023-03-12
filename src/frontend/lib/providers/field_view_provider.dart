

import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';

class FieldViewProvider extends ChangeNotifier {
  FieldModel? _field;

  FieldModel? get field => _field;

  void updateField(FieldModel field) {
    _field = field;
    notifyListeners();
  }

  void clearField() {
    _field = null;
    notifyListeners();
  }
}