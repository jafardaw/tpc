// lib/feutaure/product_batch/presentation/manger/product_batches_state.dart

abstract class ProductBatchesJState {}

class ProductBatchesJInitial extends ProductBatchesJState {}

class ProductBatchesJLoading extends ProductBatchesJState {}

class ProductBatchesJSuccess extends ProductBatchesJState {}

class ProductBatchesJFailure extends ProductBatchesJState {
  final String errorMessage;

  ProductBatchesJFailure(this.errorMessage);
}
