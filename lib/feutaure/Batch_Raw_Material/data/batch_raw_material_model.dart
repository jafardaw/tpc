// raw_material_batch_model.dart

import 'package:equatable/equatable.dart';
import 'package:tcp212/feutaure/Row_Material/data/get_raw_material_model.dart';

class RawMaterialBatchModel extends Equatable {
  final int rawMaterialBatchId;
  final int userId;
  final int rawMaterialId;
  final double quantityIn;
  final double quantityOut;
  final double quantityRemaining;
  final double realCost;
  final String paymentMethod;
  final String supplier;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GetRawMaterialModel rawMaterial; // نموذج المادة الخام المرتبطة بالدفعة

  const RawMaterialBatchModel({
    required this.rawMaterialBatchId,
    required this.userId,
    required this.rawMaterialId,
    required this.quantityIn,
    required this.quantityOut,
    required this.quantityRemaining,
    required this.realCost,
    required this.paymentMethod,
    required this.supplier,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.rawMaterial,
  });

  // دالة المصنع لإنشاء RawMaterialBatchModel من خريطة JSON
  factory RawMaterialBatchModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialBatchModel(
      rawMaterialBatchId: json['raw_material_batch_id'] as int,
      userId: json['user_id'] as int,
      rawMaterialId: json['raw_material_id'] as int,
      // تحويل القيم التي قد تأتي كسلسلة نصية إلى double
      quantityIn: double.parse(json['quantity_in'].toString()),
      quantityOut: double.parse(json['quantity_out'].toString()),
      quantityRemaining: double.parse(json['quantity_remaining'].toString()),
      realCost: double.parse(json['real_cost'].toString()),
      paymentMethod: json['payment_method'] as String,
      supplier: json['supplier'] as String,
      notes: (json['notes'] as String?)?.isNotEmpty == true
          ? json['notes'] as String
          : 'لا توجد ملاحظات',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      // إنشاء نموذج RawMaterialModel من البيانات المتداخلة
      rawMaterial: GetRawMaterialModel.fromJson(
        json['raw_material'] as Map<String, dynamic>,
      ),
    );
  }

  // دالة لتحويل RawMaterialBatchModel إلى خريطة JSON (اختياري، لكن مفيد)
  Map<String, dynamic> toJson() {
    return {
      'raw_material_batch_id': rawMaterialBatchId,
      'user_id': userId,
      'raw_material_id': rawMaterialId,
      'quantity_in': quantityIn,
      'quantity_out': quantityOut,
      'quantity_remaining': quantityRemaining,
      'real_cost': realCost,
      'payment_method': paymentMethod,
      'supplier': supplier,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'raw_material': rawMaterial.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    rawMaterialBatchId,
    userId,
    rawMaterialId,
    quantityIn,
    quantityOut,
    quantityRemaining,
    realCost,
    paymentMethod,
    supplier,
    notes,
    createdAt,
    updatedAt,
    rawMaterial,
  ];
}
