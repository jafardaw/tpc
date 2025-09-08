import 'package:tcp212/models/product_sales_model.dart';

abstract class ProductSalesState {}

class ProductSalesLoading extends ProductSalesState {}

class ProductSalesLoaded extends ProductSalesState {
  final List<ProductSale> productSales;
  ProductSalesLoaded(this.productSales);
}

class ProductSalesError extends ProductSalesState {
  final String message;
  ProductSalesError(this.message);
}

class ProductSaleDeleted extends ProductSalesState {}
