import 'package:equatable/equatable.dart';
import 'package:tcp212/feutaure/productBatch/data/product_batch_by_id_model.dart';
import 'package:tcp212/feutaure/productBatch/data/product_batch_model.dart';

abstract class ProductBatchState extends Equatable {
  const ProductBatchState();

  @override
  List<Object?> get props => [];
}

class ProductBatchInitial extends ProductBatchState {}

class ProductBatchLoading extends ProductBatchState {}

class ProductBatchLoaded extends ProductBatchState {
  final List<ProductBatch> batches;
  const ProductBatchLoaded({required this.batches});

  @override
  List<Object?> get props => [batches];
}

class ProductBatchError extends ProductBatchState {
  final String errorMessage;
  const ProductBatchError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class ProductBatchByidInitial extends ProductBatchState {}

class ProductBatchByidLoading extends ProductBatchState {}

class ProductBatchByidLoaded extends ProductBatchState {
  final ProductBatchResponseByid response;

  const ProductBatchByidLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class ProductBatchByidError extends ProductBatchState {
  final String message;

  const ProductBatchByidError(this.message);

  @override
  List<Object?> get props => [message];
}
