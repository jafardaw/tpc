// lib/feutaure/counts/presentation/cubit/raw_materials_count_state.dart

abstract class RawMaterialsCountState {}

class RawMaterialsCountInitial extends RawMaterialsCountState {}

class RawMaterialsCountLoading extends RawMaterialsCountState {}

class RawMaterialsCountLoaded extends RawMaterialsCountState {
  final int count;

  RawMaterialsCountLoaded({required this.count});
}

class RawMaterialsCountError extends RawMaterialsCountState {
  final String message;

  RawMaterialsCountError({required this.message});
}
