import 'package:tcp212/feutaure/Product/data/get_all_product_model.dart';

abstract class ProductListState {}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> products;
  ProductListLoaded({required this.products});
}

class ProductListError extends ProductListState {
  final String errorMessage;
  ProductListError({required this.errorMessage});
}
