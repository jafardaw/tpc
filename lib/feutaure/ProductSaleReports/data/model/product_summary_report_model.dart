import 'package:tcp212/feutaure/conversions/data/model/product_conversion_model.dart';

class ProductSummaryReportModel {
  final int reportId;
  final int productId;
  final double quantityProduced;
  final double quantitySold;
  final double totalCosts;
  final double totalEstimatedExpenses;
  final double totalActualExpenses;
  final double totalIncome;
  final double netProfit;
  final String type;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final ProductConversionsModel?
  product; // يمكن أن يكون null إذا لم يتم تضمينه في الاستجابة

  ProductSummaryReportModel({
    required this.reportId,
    required this.productId,
    required this.quantityProduced,
    required this.quantitySold,
    required this.totalCosts,
    required this.totalEstimatedExpenses,
    required this.totalActualExpenses,
    required this.totalIncome,
    required this.netProfit,
    required this.type,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory ProductSummaryReportModel.fromJson(Map<String, dynamic> json) {
    return ProductSummaryReportModel(
      reportId: json['report_id'] as int,
      productId: json['product_id'] as int,
      quantityProduced: double.parse(json['quantity_produced'].toString()),
      quantitySold: double.parse(json['quantity_sold'].toString()),
      totalCosts: double.parse(json['total_costs'].toString()),
      totalEstimatedExpenses: double.parse(
        json['total_estimated_expenses'].toString(),
      ),
      totalActualExpenses: double.parse(
        json['total_actual_expenses'].toString(),
      ),
      totalIncome: double.parse(json['total_income'].toString()),
      netProfit: double.parse(json['net_profit'].toString()),
      type: json['type'] as String,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      product: json['product'] != null
          ? ProductConversionsModel.fromJson(
              json['product'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
