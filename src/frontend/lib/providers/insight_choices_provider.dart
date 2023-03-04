import 'package:flutter/material.dart';
import 'package:frontend/views/insights/widgets/menu_item.dart';
import '../models/insight_model.dart';

class InsightChoicesProvider extends ChangeNotifier { 

  List<InsightType> _selectedInsights = [InsightType.disease, InsightType.pest, InsightType.nutrient];  // All choices are selected by default
  List<InsightType> get selectedInsights => _selectedInsights;

  void itemChange(InsightMenuItem item, bool isSelected) {
    if (isSelected) {
      _selectedInsights.add(item.type);
    } else {
      _selectedInsights.remove(item.type);
    }
    notifyListeners();
  }

  void clearChoices() {
    _selectedInsights.clear();
    notifyListeners();
  }



}