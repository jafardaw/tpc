class ProductConversionsModel {
  final int productId;
  final String name;
  final String description;
  final double price;
  final String category;
  final double weightPerUnit;
  final double minimumStockAlert;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductConversionsModel({
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

  factory ProductConversionsModel.fromJson(Map<String, dynamic> json) {
    return ProductConversionsModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: double.parse(json['price'].toString()), // Convert String to double
      category: json['category'] as String,
      weightPerUnit: double.parse(
          json['weight_per_unit'].toString()), // Convert String to double
      minimumStockAlert: double.parse(
          json['minimum_stock_alert'].toString()), // Convert String to double
      imagePath: json['image_path'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ProductBatchConvirsionsModel {
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
  final ProductConversionsModel? product; // Nested ProductModel

  ProductBatchConvirsionsModel({
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
    this.product,
  });

  factory ProductBatchConvirsionsModel.fromJson(Map<String, dynamic> json) {
    return ProductBatchConvirsionsModel(
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      product: json['product'] != null
          ? ProductConversionsModel.fromJson(json['product'])
          : null,
    );
  }
}

class RawMaterialConversionsModel {
  final int rawMaterialId;
  final String name;
  final String description;
  final double price;
  final String status;
  final double minimumStockAlert;
  final DateTime createdAt;
  final DateTime updatedAt;

  RawMaterialConversionsModel({
    required this.rawMaterialId,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
    required this.minimumStockAlert,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RawMaterialConversionsModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialConversionsModel(
      rawMaterialId: json['raw_material_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: double.parse(json['price'].toString()),
      status: json['status'] as String,
      minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class RawMaterialBatchConversionModel {
  final int rawMaterialBatchId;
  final int userId;
  final int rawMaterialId;
  final double quantityIn;
  final double quantityOut;
  final double quantityRemaining;
  final double realCost;
  final String paymentMethod;
  final String supplier;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RawMaterialConversionsModel? rawMaterial; // Nested RawMaterialModel

  RawMaterialBatchConversionModel({
    required this.rawMaterialBatchId,
    required this.userId,
    required this.rawMaterialId,
    required this.quantityIn,
    required this.quantityOut,
    required this.quantityRemaining,
    required this.realCost,
    required this.paymentMethod,
    required this.supplier,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.rawMaterial,
  });

  factory RawMaterialBatchConversionModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialBatchConversionModel(
      rawMaterialBatchId: json['raw_material_batch_id'] as int,
      userId: json['user_id'] as int,
      rawMaterialId: json['raw_material_id'] as int,
      quantityIn: double.parse(json['quantity_in'].toString()),
      quantityOut: double.parse(json['quantity_out'].toString()),
      quantityRemaining: double.parse(json['quantity_remaining'].toString()),
      realCost: double.parse(json['real_cost'].toString()),
      paymentMethod: json['payment_method'] as String,
      supplier: json['supplier'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      rawMaterial: json['raw_material'] != null
          ? RawMaterialConversionsModel.fromJson(json['raw_material'])
          : null,
    );
  }
}
