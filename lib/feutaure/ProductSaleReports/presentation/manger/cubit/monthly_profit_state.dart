import 'package:tcp212/feutaure/ProductSaleReports/data/model/monthly_profit_model.dart';

abstract class MonthlyProfitState {}

class MonthlyProfitInitial extends MonthlyProfitState {}

class MonthlyProfitLoading extends MonthlyProfitState {}

class MonthlyProfitLoaded extends MonthlyProfitState {
  final MonthlyProfitModel monthlyProfit;

  MonthlyProfitLoaded(this.monthlyProfit);
}

class MonthlyProfitError extends MonthlyProfitState {
  final String message;

  MonthlyProfitError(this.message);
}
