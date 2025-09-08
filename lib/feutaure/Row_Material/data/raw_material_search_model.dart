// class RawMaterialSearchResult {
//   final int rawMaterialId;
//   final String name;
//   final String description;
//   final double price;
//   final String status;
//   final double minimumStockAlert;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   RawMaterialSearchResult({
//     required this.rawMaterialId,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.status,
//     required this.minimumStockAlert,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory RawMaterialSearchResult.fromJson(Map<String, dynamic> json) {
//     return RawMaterialSearchResult(
//       rawMaterialId: json['raw_material_id'] as int,
//       name: json['name'] as String,
//       description: json['description'] as String,
//       price: double.tryParse(json['price'].toString()) ?? 0.0,
//       status: json['status'] as String,
//       minimumStockAlert:
//           double.tryParse(json['minimum_stock_alert'].toString()) ?? 0.0,
//       createdAt: DateTime.parse(json['created_at'] as String),
//       updatedAt: DateTime.parse(json['updated_at'] as String),
//     );
//   }
// }
