// lib/feutaure/product_batch/data/model/product_batch_model.dart

// إضافة نموذج جديد للتعديل
class UpdateProductBatcJhModel {
  final int quantityIn;
  final String? notes;
  final String status;
  final int? reproductionCount;

  UpdateProductBatcJhModel({
    required this.quantityIn,
    this.notes,
    required this.status,
    this.reproductionCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity_in': quantityIn,
      'notes': notes,
      'status': status,
      'reproduction_count': reproductionCount,
    };
  }
}
