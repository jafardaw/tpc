class UpdateProductState {}

final class UpdateProductInitial extends UpdateProductState {}

final class UpdateProductLoading extends UpdateProductState {}

final class UpdateProductSuccess extends UpdateProductState {
  final String message;
  UpdateProductSuccess(this.message);
}

final class UpdateProductError extends UpdateProductState {
  final String message;
  UpdateProductError(this.message);
}

final class DeleatProductInitial extends UpdateProductState {}

final class DeleatProductLoading extends UpdateProductState {}

final class DeleatProductSuccess extends UpdateProductState {
  final String message;
  DeleatProductSuccess(this.message);
}

final class DeleatroductError extends UpdateProductState {
  final String message;
  DeleatroductError(this.message);
}
