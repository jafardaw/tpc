import 'package:bloc/bloc.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/manger/cubit/monthly_profit_state.dart';
import 'package:tcp212/feutaure/ProductSaleReports/repo/product_summary_repository_imp.dart';

class MonthlyProfitCubit extends Cubit<MonthlyProfitState> {
  final ProductSummaryRepositoryImp _productSummaryRepository;

  MonthlyProfitCubit(this._productSummaryRepository)
    : super(MonthlyProfitInitial());

  Future<void> fetchMonthlyProfit() async {
    emit(MonthlyProfitLoading());
    try {
      final profit = await _productSummaryRepository.getMonthlyProfit();
      emit(MonthlyProfitLoaded(profit));
    } catch (e) {
      emit(MonthlyProfitError(e.toString()));
    }
  }
}
