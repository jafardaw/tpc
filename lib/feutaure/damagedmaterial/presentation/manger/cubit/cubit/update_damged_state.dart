import 'package:tcp212/feutaure/profit-loss-report/data/model/sub_profit-loss-report_model.dart';

abstract class UpdateDamgedState {}

class UpdateDamgedInitial extends UpdateDamgedState {}

class DamagedMaterialUpdating extends UpdateDamgedState {}

class DamagedMaterialUpdateSuccess extends UpdateDamgedState {
  final DamagedMaterialProfitLossReportModel updatedMaterial;
  final String message;
  DamagedMaterialUpdateSuccess(this.updatedMaterial, this.message);
}

class DamagedMaterialUpdateError extends UpdateDamgedState {
  final String message;
  DamagedMaterialUpdateError(this.message);
}
