import 'package:equatable/equatable.dart';

class SimiProductModel extends Equatable {
  final int productId;
  final String name;
  final String description;
  final String price;
  final String category;
  final String weightPerUnit;
  final String minimumStockAlert;
  final String? imagePath;
  final String createdAt;
  final String updatedAt;

  const SimiProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.weightPerUnit,
    required this.minimumStockAlert,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SimiProductModel.fromJson(Map<String, dynamic> json) {
    return SimiProductModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      category: json['category'] as String,
      weightPerUnit: json['weight_per_unit'] as String,
      minimumStockAlert: json['minimum_stock_alert'] as String,
      imagePath: json['image_path'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        name,
        description,
        price,
        category,
        weightPerUnit,
        minimumStockAlert,
        imagePath,
        createdAt,
        updatedAt,
      ];
}
