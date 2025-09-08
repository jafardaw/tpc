import 'package:tcp212/feutaure/profit-loss-report/data/model/profit_loss_report_model.dart';

abstract class ProfitLossState {}

class ProfitLossInitial extends ProfitLossState {}

class ProfitLossLoading extends ProfitLossState {}

class ProfitLossLoaded extends ProfitLossState {
  final List<ProfitLossReportModel> reports;

  ProfitLossLoaded(this.reports);
}

class ProfitLossError extends ProfitLossState {
  final String message;

  ProfitLossError(this.message);
}
