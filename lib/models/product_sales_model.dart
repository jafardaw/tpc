class Product {
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

  Product({
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

  factory Product.fromJson(Map<String, dynamic> json) {
    final dynamic imagePathRaw = json['image_path'];
    String? imagePath;
    if (imagePathRaw != null && imagePathRaw is String && imagePathRaw.isNotEmpty) {
      imagePath = imagePathRaw;
    } else {
      imagePath = null;
    }
    return Product(
      productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      category: json['category']?.toString() ?? '',
      weightPerUnit: double.tryParse(json['weight_per_unit']?.toString() ?? '') ?? 0.0,
      minimumStockAlert: double.tryParse(json['minimum_stock_alert']?.toString() ?? '') ?? 0.0,
      imagePath: imagePath,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'description': description,
      'price': price.toStringAsFixed(2),
      'category': category,
      'weight_per_unit': weightPerUnit.toString(),
      'minimum_stock_alert': minimumStockAlert.toStringAsFixed(2),
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
class ProductBatch {
  final int productBatchId;
  final int userId;
  final int productId;
  final double quantityIn;
  final double quantityOut;
  final double quantityRemaining;
  final double realCost;
  final String notes;
  final String status;
  final int reproductionCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductBatch({
    required this.productBatchId,
    required this.userId,
    required this.productId,
    required this.quantityIn,
    required this.quantityOut,
    required this.quantityRemaining,
    required this.realCost,
    required this.notes,
    required this.status,
    required this.reproductionCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductBatch.fromJson(Map<String, dynamic> json) {
    return ProductBatch(
      productBatchId: json['product_batch_id'] is int ? json['product_batch_id'] : int.tryParse(json['product_batch_id'].toString()) ?? 0,
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? 0,
      productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id'].toString()) ?? 0,
      quantityIn: double.tryParse(json['quantity_in']?.toString() ?? '') ?? 0.0,
      quantityOut: double.tryParse(json['quantity_out']?.toString() ?? '') ?? 0.0,
      quantityRemaining: double.tryParse(json['quantity_remaining']?.toString() ?? '') ?? 0.0,
      realCost: double.tryParse(json['real_cost']?.toString() ?? '') ?? 0.0,
      notes: json['notes']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      reproductionCount: json['reproduction_count'] is int ? json['reproduction_count'] : int.tryParse(json['reproduction_count'].toString()) ?? 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_batch_id': productBatchId,
      'user_id': userId,
      'product_id': productId,
      'quantity_in': quantityIn.toStringAsFixed(2),
      'quantity_out': quantityOut.toStringAsFixed(2),
      'quantity_remaining': quantityRemaining.toStringAsFixed(2),
      'real_cost': realCost.toStringAsFixed(2),
      'notes': notes,
      'status': status,
      'reproduction_count': reproductionCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
class ProductSale {
  final int productSaleId;
  final int productId;
  final int productBatchId;
  final int userId;
  final double quantitySold;
  final double unitPrice;
  final double revenue;
  final String customer;
  final double netProfit;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;
  final ProductBatch productBatch;

  ProductSale({
    required this.productSaleId,
    required this.productId,
    required this.productBatchId,
    required this.userId,
    required this.quantitySold,
    required this.unitPrice,
    required this.revenue,
    required this.customer,
    required this.netProfit,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
    required this.productBatch,
  });

  factory ProductSale.fromJson(Map<String, dynamic> json) {
    return ProductSale(
      productSaleId: json['product_sale_id'] is int ? json['product_sale_id'] : int.tryParse(json['product_sale_id'].toString()) ?? 0,
      productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id'].toString()) ?? 0,
      productBatchId: json['product_batch_id'] is int ? json['product_batch_id'] : int.tryParse(json['product_batch_id'].toString()) ?? 0,
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? 0,
      quantitySold: double.tryParse(json['quantity_sold']?.toString() ?? '') ?? 0.0,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '') ?? 0.0,
      revenue: double.tryParse(json['revenue']?.toString() ?? '') ?? 0.0,
      customer: json['customer']?.toString() ?? '',
      netProfit: double.tryParse(json['net_profit']?.toString() ?? '') ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      productBatch: ProductBatch.fromJson(json['product_batch'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_sale_id': productSaleId,
      'product_id': productId,
      'product_batch_id': productBatchId,
      'user_id': userId,
      'quantity_sold': quantitySold.toStringAsFixed(2),
      'unit_price': unitPrice.toStringAsFixed(2),
      'revenue': revenue.toStringAsFixed(2),
      'customer': customer,
      'net_profit': netProfit.toStringAsFixed(2),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'product': product.toJson(),
      'product_batch': productBatch.toJson(),
    };
  }
}