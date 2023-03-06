import 'package:flutter/material.dart';

import '../../../models/insight_model.dart';


/// Items displayed in checklist for user to select which insights to visualize
class InsightMenuItem {

  final String title; // Pests, diseases, nutrient deficiencies..
  final IconData icon;
  final InsightType type;

  const InsightMenuItem(this.title, this.icon, this.type);

}