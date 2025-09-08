import 'package:tcp212/feutaure/conversions/data/model/product_conversion_model.dart';

class ConversionModel {
  final int conversionId;
  final int? rawMaterialBatchId;
  final int? inputProductBatchId;
  final int? outputProductBatchId;
  final String batchType; // "raw_material" or "product"
  final double quantityUsed;
  final double cost;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductBatchConvirsionsModel?
  outputProductBatch; // Nested Output Product Batch
  final ProductBatchConvirsionsModel?
  inputProductBatch; // Nested Input Product Batch
  final RawMaterialBatchConversionModel?
  rawMaterialBatch; // Nested Raw Material Batch

  ConversionModel({
    required this.conversionId,
    this.rawMaterialBatchId,
    this.inputProductBatchId,
    this.outputProductBatchId,
    required this.batchType,
    required this.quantityUsed,
    required this.cost,
    required this.createdAt,
    required this.updatedAt,
    this.outputProductBatch,
    this.inputProductBatch,
    this.rawMaterialBatch,
  });

  factory ConversionModel.fromJson(Map<String, dynamic> json) {
    return ConversionModel(
      conversionId: json['conversion_id'] as int,
      rawMaterialBatchId: json['raw_material_batch_id'] as int?,
      inputProductBatchId: json['input_product_batch_id'] as int?,
      outputProductBatchId: json['output_product_batch_id'] as int?,
      batchType: json['batch_type'] as String,
      quantityUsed: double.parse(json['quantity_used'].toString()),
      cost: double.parse(json['cost'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      outputProductBatch: json['output_product_batch'] != null
          ? ProductBatchConvirsionsModel.fromJson(json['output_product_batch'])
          : null,
      inputProductBatch: json['input_product_batch'] != null
          ? ProductBatchConvirsionsModel.fromJson(json['input_product_batch'])
          : null,
      rawMaterialBatch: json['raw_material_batch'] != null
          ? RawMaterialBatchConversionModel.fromJson(json['raw_material_batch'])
          : null,
    );
  }
}
