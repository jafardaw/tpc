abstract class UpdateBatchRawMaterialState {}

class UpdateBatchRawMaterialInitial extends UpdateBatchRawMaterialState {}

class UpdateBatchRawMaterialLoading extends UpdateBatchRawMaterialState {}

class UpdateBatchRawMaterialSuccess extends UpdateBatchRawMaterialState {
  final String message;
  UpdateBatchRawMaterialSuccess({required this.message});
}

class UpdateBatchRawMaterialError extends UpdateBatchRawMaterialState {
  final String errorMessage;
  UpdateBatchRawMaterialError({required this.errorMessage});
}

final class DeleatBatchRawMaterialInitial extends UpdateBatchRawMaterialState {}

final class DeleatBatchRawMaterialLoading extends UpdateBatchRawMaterialState {}

final class DeleatBatchRawMaterialSuccess extends UpdateBatchRawMaterialState {
  final String message;
  DeleatBatchRawMaterialSuccess(this.message);
}

final class DeleatBatchRawMaterialError extends UpdateBatchRawMaterialState {
  final String message;
  DeleatBatchRawMaterialError(this.message);
}
