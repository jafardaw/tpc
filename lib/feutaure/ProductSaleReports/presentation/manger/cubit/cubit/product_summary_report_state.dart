import 'package:tcp212/feutaure/ProductSaleReports/data/model/product_summary_report_model.dart';

abstract class ProductSummaryReportState {}

class ProductSummaryReportInitial extends ProductSummaryReportState {}

class ProductSummaryReportLoading extends ProductSummaryReportState {}

class ProductSummaryReportLoaded extends ProductSummaryReportState {
  final List<ProductSummaryReportModel> reports;

  ProductSummaryReportLoaded(this.reports);
}

class ProductSummaryReportError extends ProductSummaryReportState {
  final String message;

  ProductSummaryReportError(this.message);
}
