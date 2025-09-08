import 'package:tcp212/feutaure/profit-loss-report/data/model/sub_profit-loss-report_model.dart';

class ProfitLossReportModel {
  final int reportId;
  final int? productSaleId;
  final int? damagedMaterialId;
  final String type; // "profit" or "loss"
  final double netProfitLoss;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final ProductSaleProfitLossReportModel? productSale;
  final DamagedMaterialProfitLossReportModel?
  damagedMaterial; // الآن يمكن أن يحتوي على هذا

  ProfitLossReportModel({
    required this.reportId,
    this.productSaleId,
    this.damagedMaterialId,
    required this.type,
    required this.netProfitLoss,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.productSale,
    this.damagedMaterial, // تأكد من إضافته هنا
  });

  factory ProfitLossReportModel.fromJson(Map<String, dynamic> json) {
    return ProfitLossReportModel(
      reportId: json['report_id'] as int,
      productSaleId: json['product_sale_id'] as int?,
      damagedMaterialId: json['damaged_material_id'] as int?,
      type: json['type'] as String,
      netProfitLoss: double.parse(json['net_profit_loss'].toString()),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      productSale: json['product_sale'] != null
          ? ProductSaleProfitLossReportModel.fromJson(
              json['product_sale'] as Map<String, dynamic>,
            )
          : null,
      damagedMaterial: json['damaged_material'] != null
          ? DamagedMaterialProfitLossReportModel.fromJson(
              json['damaged_material'] as Map<String, dynamic>,
            )
          : null, // تأكد من التعامل مع هذا هنا
    );
  }
}
