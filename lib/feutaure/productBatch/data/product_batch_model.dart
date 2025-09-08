import 'package:equatable/equatable.dart';

class ProductBatchResponse extends Equatable {
  final int status;
  final List<ProductBatch> data;

  const ProductBatchResponse({required this.status, required this.data});

  factory ProductBatchResponse.fromJson(Map<String, dynamic> json) {
    return ProductBatchResponse(
      status: json['status'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => ProductBatch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [status, data];
}

class ProductBatch extends Equatable {
  final int productBatchId;
  final int userId;
  final int productId;
  final double quantityIn;
  final double quantityOut;
  final double quantityRemaining;
  final double realCost;
  final String? notes;
  final String status;
  final int reproductionCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  const ProductBatch({
    required this.productBatchId,
    required this.userId,
    required this.productId,
    required this.quantityIn,
    required this.quantityOut,
    required this.quantityRemaining,
    required this.realCost,
    this.notes,
    required this.status,
    required this.reproductionCount,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory ProductBatch.fromJson(Map<String, dynamic> json) {
    return ProductBatch(
      productBatchId: json['product_batch_id'] as int,
      userId: json['user_id'] as int,
      productId: json['product_id'] as int,
      quantityIn: double.parse(json['quantity_in'].toString()),
      quantityOut: double.parse(json['quantity_out'].toString()),
      quantityRemaining: double.parse(json['quantity_remaining'].toString()),
      realCost: double.parse(json['real_cost'].toString()),
      notes: json['notes'] as String?,
      status: json['status'] as String,
      reproductionCount: json['reproduction_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [
        productBatchId,
        userId,
        productId,
        quantityIn,
        quantityOut,
        quantityRemaining,
        realCost,
        notes,
        status,
        reproductionCount,
        createdAt,
        updatedAt,
        product,
      ];
}

class Product extends Equatable {
  final int productId;
  final String name;
  final String? description;
  final double price;
  final String category;
  final double weightPerUnit;
  final double minimumStockAlert;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.productId,
    required this.name,
    this.description,
    required this.price,
    required this.category,
    required this.weightPerUnit,
    required this.minimumStockAlert,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: double.parse(json['price'].toString()),
      category: json['category'] as String,
      weightPerUnit: double.parse(json['weight_per_unit'].toString()),
      minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
      imagePath: json['image_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
