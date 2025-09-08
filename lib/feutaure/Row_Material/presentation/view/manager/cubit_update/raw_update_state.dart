class UpdateRawmaterialState {}

final class UpdateRawMaterialInitial extends UpdateRawmaterialState {}

final class UpdateRawMaterialLoading extends UpdateRawmaterialState {}

final class UpdateRawMaterialSuccess extends UpdateRawmaterialState {
  final String message;
  UpdateRawMaterialSuccess(this.message);
}

final class UpdateRawMaterialError extends UpdateRawmaterialState {
  final String message;
  UpdateRawMaterialError(this.message);
}

final class DeleatRawMaterialInitial extends UpdateRawmaterialState {}

final class DeleatRawMaterialLoading extends UpdateRawmaterialState {}

final class DeleatRawMaterialSuccess extends UpdateRawmaterialState {
  final String message;
  DeleatRawMaterialSuccess(this.message);
}

final class DeleatRawMaterialError extends UpdateRawmaterialState {
  final String message;
  DeleatRawMaterialError(this.message);
}
