import 'package:flutter/material.dart';
import '../models/insight_model.dart';


enum InsightMapType { 
  ndvi, 
  soil_moisture 
}

/// A provider that stores the user's choices for insights
class InsightChoicesProvider extends ChangeNotifier { 
  
  List<String> _excludedInsightsTypes = [];  // All choices are selected by default
  List<String> get excludedInsightsTypes => _excludedInsightsTypes;

  InsightMapType _currInsightMapType = InsightMapType.ndvi;
  InsightMapType get currInsightMapType => _currInsightMapType;

  /// Sets the selection state of the given [insightType] to [isSelected].
  /// If [isSelected] is true, the [insightType] is added to the list of selected insights.
  /// Otherwise, the [insightType] is removed from the list of selected insights.
  void setInsightTypeSelection(String insightType, bool isSelected) {
    if (isSelected) {
      _excludedInsightsTypes.remove(insightType);
    } else {
      _excludedInsightsTypes.add(insightType);
    }
    notifyListeners();
  }

  /// Toggles the selection state of the given [insightType].
  /// If the [insightType] is selected, it is removed from the list of selected insights.
  /// Otherwise, it is added to the list of selected insights.
  void toggleInsightTypeSelection(String insightType) {
    if (isInsightTypeSelected(insightType)) {
      _excludedInsightsTypes.add(insightType);
    } else {
      _excludedInsightsTypes.remove(insightType);
    }
    notifyListeners();
  }

  /// Returns true if the given [insightType] is selected by the user.
  /// Otherwise, returns false.
  bool isInsightTypeSelected(String insightType) {
    return !_excludedInsightsTypes.contains(insightType);
  }
  
  /// Sets the current insight map type to [insightMapType].
  /// If [insightMapType] is null, the current insight map type is set to [InsightMapType.ndvi].
  /// Otherwise, the current insight map type is set to [insightMapType].
  void setInsightMapType(InsightMapType? insightMapType) {
    _currInsightMapType = insightMapType ?? InsightMapType.ndvi;
    notifyListeners();
  }
}