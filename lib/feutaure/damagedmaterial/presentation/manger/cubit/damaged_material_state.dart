import 'package:tcp212/feutaure/profit-loss-report/data/model/sub_profit-loss-report_model.dart';

abstract class DamagedMaterialsState {}

class DamagedMaterialsInitial extends DamagedMaterialsState {}

class DamagedMaterialsLoading extends DamagedMaterialsState {}

class DamagedMaterialsLoaded extends DamagedMaterialsState {
  final List<DamagedMaterialProfitLossReportModel> damagedMaterials;

  DamagedMaterialsLoaded(this.damagedMaterials);
}

class DamagedMaterialsError extends DamagedMaterialsState {
  final String message;

  DamagedMaterialsError(this.message);
}

class DamagedMaterialDeleting extends DamagedMaterialsState {}

class DamagedMaterialDeletedSuccess extends DamagedMaterialsState {
  final String message;
  DamagedMaterialDeletedSuccess(this.message);
}

class DamagedMaterialDeleteError extends DamagedMaterialsState {
  final String message;
  DamagedMaterialDeleteError(this.message);
}
