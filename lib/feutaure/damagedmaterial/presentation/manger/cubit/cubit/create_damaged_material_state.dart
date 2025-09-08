import 'package:tcp212/feutaure/profit-loss-report/data/model/sub_profit-loss-report_model.dart';

abstract class CreateDamagedMaterialState {}

class CreateDamagedMaterialInitial extends CreateDamagedMaterialState {}

class CreateDamagedMaterialLoading extends CreateDamagedMaterialState {}

class CreateDamagedMaterialSuccess extends CreateDamagedMaterialState {
  final DamagedMaterialProfitLossReportModel newMaterial;
  final String message;

  CreateDamagedMaterialSuccess(this.newMaterial, this.message);
}

class CreateDamagedMaterialError extends CreateDamagedMaterialState {
  final String message;

  CreateDamagedMaterialError(this.message);
}
