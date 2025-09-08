// lib/models/raw_material.dart
class GetRawMaterialModel {
  final int rawMaterialId; // هنا يجب أن يكون غير قابل للقيمة الفارغة
  final String name;
  final String description;
  final double price; // تم التعديل إلى double
  final String status;
  final int minimumStockAlert; // تم التعديل إلى int
  final DateTime createdAt;
  final DateTime updatedAt;

  GetRawMaterialModel({
    required this.rawMaterialId,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
    required this.minimumStockAlert,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a RawMaterial from a JSON map
  factory GetRawMaterialModel.fromJson(Map<String, dynamic> json) {
    return GetRawMaterialModel(
      rawMaterialId: json['raw_material_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      // تحويل String إلى double
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      status: json['status'] as String,
      // تحويل String إلى int
      minimumStockAlert: int.tryParse(
              json['minimum_stock_alert'].toString().split('.').first) ??
          0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Method to convert a RawMaterial object to a JSON map (لإرسال البيانات)
  Map<String, dynamic> toJson() {
    return {
      'raw_material_id': rawMaterialId,
      'name': name,
      'description': description,
      'price': price.toString(), // أعدها كـ String إذا كان الـ API يتوقع ذلك
      'status': status,
      'minimum_stock_alert': minimumStockAlert.toString(), // أعدها كـ String
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
