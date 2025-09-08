// lib/models/raw_material.dart
class RawMaterial {
  final int? rawMaterialId; // Nullable for new entries
  final String name;
  final String description;
  final double price;
  final String status;
  final int minimumStockAlert;

  RawMaterial({
    this.rawMaterialId,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
    required this.minimumStockAlert,
  });

  // Factory constructor to create a RawMaterial from a JSON map
  factory RawMaterial.fromJson(Map<String, dynamic> json) {
    return RawMaterial(
      rawMaterialId: json['raw_material_id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(), // Ensure double
      status: json['status'] as String,
      minimumStockAlert: json['minimum_stock_alert'] as int,
    );
  }

  // Method to convert a RawMaterial object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'status': status,
      'minimum_stock_alert': minimumStockAlert,
    };
  }
}
