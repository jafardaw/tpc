part of 'products_count_cubit.dart';

abstract class ProductsCountState {}

class ProductsCountInitial extends ProductsCountState {}

class ProductsCountLoading extends ProductsCountState {}

class ProductsCountLoaded extends ProductsCountState {
  final String count;

  ProductsCountLoaded({required this.count});
}

class ProductsCountError extends ProductsCountState {
  final String message;

  ProductsCountError({required this.message});
}
