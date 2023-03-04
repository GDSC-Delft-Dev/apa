import 'package:flutter/material.dart';
import 'package:frontend/views/insights/widgets/menu_item.dart';
import '../views/insights/widgets/hidden_drawer.dart';

class InsightChoicesProvider extends ChangeNotifier { 

  List<InsightMenuItem> _selectedInsights = [...InsightMenuItems.choices];  // All choices are selected by default
  List<InsightMenuItem> get selectedInsights => _selectedInsights;

  void itemChange(InsightMenuItem item, bool isSelected) {
    if (isSelected) {
      _selectedInsights.add(item);
    } else {
      _selectedInsights.remove(item);
    }
    notifyListeners();
  }

  void clearChoices() {
    _selectedInsights.clear();
    notifyListeners();
  }



}