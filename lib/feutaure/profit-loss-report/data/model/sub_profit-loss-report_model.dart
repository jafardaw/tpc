class RawMaterialProfitLossReportModel {
  final int rawMaterialId;
  final String name;
  final String description;
  final double price;
  final String status;
  final double minimumStockAlert;
  final String createdAt;
  final String updatedAt;

  RawMaterialProfitLossReportModel({
    required this.rawMaterialId,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
    required this.minimumStockAlert,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RawMaterialProfitLossReportModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialProfitLossReportModel(
      rawMaterialId: json['raw_material_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: double.parse(json['price'].toString()),
      status: json['status'] as String,
      minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class RawMaterialBatchProfitLossReportModel {
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
  final String createdAt;
  final String updatedAt;
  final RawMaterialProfitLossReportModel? rawMaterial;

  RawMaterialBatchProfitLossReportModel({
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

  factory RawMaterialBatchProfitLossReportModel.fromJson(
      Map<String, dynamic> json) {
    return RawMaterialBatchProfitLossReportModel(
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
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      rawMaterial: json['raw_material'] != null
          ? RawMaterialProfitLossReportModel.fromJson(
              json['raw_material'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DamagedMaterialProfitLossReportModel {
  final int damagedMaterialId;
  final int? productBatchId;
  final int? rawMaterialBatchId;
  final int userId;
  final String? notes;
  final double quantity;
  final String materialType;
  final double lostCost;
  final String createdAt;
  final String updatedAt;
  final ProductBatchProfitLossReportModel? productBatch;
  final RawMaterialBatchProfitLossReportModel? rawMaterialBatch;

  DamagedMaterialProfitLossReportModel({
    required this.damagedMaterialId,
    this.productBatchId,
    this.rawMaterialBatchId,
    required this.userId,
    this.notes,
    required this.quantity,
    required this.materialType,
    required this.lostCost,
    required this.createdAt,
    required this.updatedAt,
    this.productBatch,
    this.rawMaterialBatch,
  });

  factory DamagedMaterialProfitLossReportModel.fromJson(
      Map<String, dynamic> json) {
    return DamagedMaterialProfitLossReportModel(
      damagedMaterialId: json['damaged_material_id'] as int,
      productBatchId: json['product_batch_id'] as int?,
      rawMaterialBatchId: json['raw_material_batch_id'] as int?,
      userId: json['user_id'] as int,
      notes: json['notes'] as String?,
      quantity: double.parse(json['quantity'].toString()),
      materialType: json['material_type'] as String,
      lostCost: double.parse(json['lost_cost'].toString()),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      productBatch: json['product_batch'] != null
          ? ProductBatchProfitLossReportModel.fromJson(
              json['product_batch'] as Map<String, dynamic>)
          : null,
      rawMaterialBatch: json['raw_material_batch'] != null
          ? RawMaterialBatchProfitLossReportModel.fromJson(
              json['raw_material_batch'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProductBatchProfitLossReportModel {
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
  final String createdAt;
  final String updatedAt;
  final ProductProfitLossReportModel?
      product; // يمكن أن يكون null إذا لم يتم تضمينه

  ProductBatchProfitLossReportModel({
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

  factory ProductBatchProfitLossReportModel.fromJson(
      Map<String, dynamic> json) {
    return ProductBatchProfitLossReportModel(
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
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      product: json['product'] != null
          ? ProductProfitLossReportModel.fromJson(
              json['product'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProductProfitLossReportModel {
  final int productId;
  final String name;
  final String description;
  final double price;
  final String category;
  final double weightPerUnit;
  final double minimumStockAlert;
  final String? imagePath;
  final String createdAt;
  final String updatedAt;

  ProductProfitLossReportModel({
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

  factory ProductProfitLossReportModel.fromJson(Map<String, dynamic> json) {
    return ProductProfitLossReportModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: double.parse(json['price'].toString()),
      category: json['category'] as String,
      weightPerUnit: double.parse(json['weight_per_unit'].toString()),
      minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
      imagePath: json['image_path'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class ProductSaleProfitLossReportModel {
  final int productSaleId;
  final int productId;
  final int productBatchId;
  final int userId;
  final double quantitySold;
  final double unitPrice;
  final double revenue;
  final String customer;
  final double netProfit;
  final String createdAt;
  final String updatedAt;
  final ProductBatchProfitLossReportModel? productBatch; // يمكن أن يكون null

  ProductSaleProfitLossReportModel({
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
    this.productBatch,
  });

  factory ProductSaleProfitLossReportModel.fromJson(Map<String, dynamic> json) {
    return ProductSaleProfitLossReportModel(
      productSaleId: json['product_sale_id'] as int,
      productId: json['product_id'] as int,
      productBatchId: json['product_batch_id'] as int,
      userId: json['user_id'] as int,
      quantitySold: double.parse(json['quantity_sold'].toString()),
      unitPrice: double.parse(json['unit_price'].toString()),
      revenue: double.parse(json['revenue'].toString()),
      customer: json['customer'] as String,
      netProfit: double.parse(json['net_profit'].toString()),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      productBatch: json['product_batch'] != null
          ? ProductBatchProfitLossReportModel.fromJson(
              json['product_batch'] as Map<String, dynamic>)
          : null,
    );
  }
}
