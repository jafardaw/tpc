sealed class AddRawMaterialState {}

final class AddRawMaterialInitial extends AddRawMaterialState {}

final class AddRawMaterialLoading extends AddRawMaterialState {}

final class AddRawMaterialSuccess extends AddRawMaterialState {
  final String message;
  AddRawMaterialSuccess(this.message);
}

final class AddRawMaterialError extends AddRawMaterialState {
  final String message;
  AddRawMaterialError(this.message);
}
