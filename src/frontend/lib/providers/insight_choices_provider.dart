import 'package:flutter/material.dart';
import 'package:frontend/views/insights/widgets/menu_item.dart';
import '../models/insight_model.dart';


enum InsightMapType { 
  ndvi, 
  soil_moisture 
}

/// A provider that stores the user's choices for insights
class InsightChoicesProvider extends ChangeNotifier { 

  List<InsightType> _selectedInsights = [InsightType.disease, InsightType.pest, InsightType.nutrient];  // All choices are selected by default
  List<InsightType> get selectedInsights => _selectedInsights;
  InsightMapType _currInsightMapType = InsightMapType.ndvi;
  InsightMapType get currInsightMapType => _currInsightMapType;

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

  void setInsightMapType(InsightMapType type) {
    _currInsightMapType = type;
    notifyListeners();
  }
}