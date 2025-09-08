import 'package:bloc/bloc.dart';
import 'package:tcp212/feutaure/profit-loss-report/presentation/manger/cubit/profit_loss_state.dart';
import 'package:tcp212/feutaure/profit-loss-report/repo/profit_loss_repository_imp.dart';

class ProfitLossCubit extends Cubit<ProfitLossState> {
  final ProfitLossRepositoryImp _profitLossRepository;

  ProfitLossCubit(this._profitLossRepository) : super(ProfitLossInitial());

  Future<void> fetchProfitLossReport() async {
    emit(ProfitLossLoading());
    try {
      final reports = await _profitLossRepository.getProfitLossReport();
      emit(ProfitLossLoaded(reports));
    } catch (e) {
      emit(ProfitLossError(e.toString()));
    }
  }
}
