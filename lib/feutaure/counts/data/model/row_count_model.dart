// lib/feutaure/counts/data/models/raw_materials_count_model.dart
class RawMaterialsCountModel {
  final int count;

  RawMaterialsCountModel({required this.count});

  factory RawMaterialsCountModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialsCountModel(
      count: json['used materials count'] ?? 0,
    );
  }
}
