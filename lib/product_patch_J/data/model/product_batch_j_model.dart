// lib/feutaure/product_batch/data/model/product_batch_model.dart

class CreateProductBatchJModel {
  final int productId;
  final int quantityIn;
  final String? notes;
  final String status;
  final int? reproductionCount;

  CreateProductBatchJModel({
    required this.productId,
    required this.quantityIn,
    this.notes,
    required this.status,
    this.reproductionCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity_in': quantityIn,
      'notes': notes,
      'status': status,
      'reproduction_count': reproductionCount,
    };
  }
}
