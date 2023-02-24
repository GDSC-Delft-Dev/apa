
/// Represents a field (set of geopoints) owned by some user
class FieldModel {

  final String fieldId;
  final String fieldName;
  final double area;
  bool hasInsights;

  FieldModel({
    required this.fieldId,
    required this.fieldName,
    required this.area,
    this.hasInsights = false });

  setHasInsights(bool hasInsights) {
    this.hasInsights = hasInsights;
  }

}