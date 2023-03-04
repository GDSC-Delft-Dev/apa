
class CropModel {
  final String cropId;
  final String name;
  final String type;

  CropModel({
    required this.cropId,
    required this.name,
    required this.type,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      cropId: json['crop_id'],
      name: json['name'],
      type: json['type'],
    );
  }
}