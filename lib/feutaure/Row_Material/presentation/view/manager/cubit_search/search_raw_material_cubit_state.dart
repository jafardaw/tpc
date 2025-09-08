import 'package:tcp212/feutaure/Row_Material/data/get_raw_material_model.dart';

abstract class RawMaterialSearchState {}

class RawMaterialSearchInitial extends RawMaterialSearchState {}

class RawMaterialSearchLoading extends RawMaterialSearchState {}

class RawMaterialSearchSuccess extends RawMaterialSearchState {
  final List<GetRawMaterialModel> results;

  RawMaterialSearchSuccess(this.results);
}

class RawMaterialSearchError extends RawMaterialSearchState {
  final String message;

  RawMaterialSearchError(this.message);
}
