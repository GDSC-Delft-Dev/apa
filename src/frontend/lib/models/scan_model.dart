// Represents a scan of a field
import 'package:frontend/models/insight_model.dart';

class ScanModel {
  final String scanId;
  final DateTime startDate;
  final DateTime endDate;
  final Result result;
  final String drone;
  final List<InsightModel> insights;
  final List<String> pipelines;
  final Map<String, dynamic> indices;
  
  ScanModel({
    required this.scanId,
    required this.startDate,
    required this.endDate,
    required this.result,
    required this.drone,
    required this.insights,
    required this.pipelines,
    required this.indices,
  });
}

enum Result { success, undefined, partialSuccess, failure }
