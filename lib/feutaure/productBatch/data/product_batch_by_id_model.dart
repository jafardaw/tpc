class ProductBatchResponseByid {
  final int status;
  final int productId;
  final List<ProductBatchByid> data;

  ProductBatchResponseByid({
    required this.status,
    required this.productId,
    required this.data,
  });

  factory ProductBatchResponseByid.fromJson(Map<String, dynamic> json) {
    return ProductBatchResponseByid(
      status: json['status'] as int,
      productId: int.parse(json['product_id'].toString()),
      data: (json['data'] as List<dynamic>)
          .map((e) => ProductBatchByid.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'product_id': productId,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class ProductBatchByid {
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

  ProductBatchByid({
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

  factory ProductBatchByid.fromJson(Map<String, dynamic> json) {
    return ProductBatchByid(
      productBatchId: json['product_batch_id'] as int,
      userId: json['user_id'] as int,
      productId: json['product_id'] as int,
      quantityIn: double.parse(json['quantity_in'].toString()),
      quantityOut: double.parse(json['quantity_out'].toString()),
      quantityRemaining: double.parse(json['quantity_remaining'].toString()),
      realCost: double.parse(json['real_cost'].toString()),
      notes: json['notes'] as String,
      status: json['status'] as String,
      reproductionCount: json['reproduction_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'product_batch_id': productBatchId,
        'user_id': userId,
        'product_id': productId,
        'quantity_in': quantityIn,
        'quantity_out': quantityOut,
        'quantity_remaining': quantityRemaining,
        'real_cost': realCost,
        'notes': notes,
        'status': status,
        'reproduction_count': reproductionCount,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
