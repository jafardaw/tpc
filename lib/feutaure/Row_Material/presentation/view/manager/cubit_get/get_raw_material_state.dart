import 'package:tcp212/feutaure/Row_Material/data/get_raw_material_model.dart';

sealed class GetRawMaterialsState {}

final class GetRawMaterialsInitial extends GetRawMaterialsState {}

final class GetRawMaterialsLoading extends GetRawMaterialsState {}

final class GetRawMaterialsSuccess extends GetRawMaterialsState {
  final List<GetRawMaterialModel> rawMaterials;

  GetRawMaterialsSuccess(this.rawMaterials);
}

final class GetRawMaterialsError extends GetRawMaterialsState {
  final String message;

  GetRawMaterialsError(this.message);
}
