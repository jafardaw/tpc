import 'package:bloc/bloc.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/get_production_setting_by_month_state.dart';
import 'package:tcp212/feutaure/ProductionSettings/repo/production_settings_repo.dart'; // تأكد من المسار

class GetProductionSettingCubit extends Cubit<GetProductionSettingState> {
  final ProductionSettingsRepo repository;

  GetProductionSettingCubit({required this.repository})
    : super(GetProductionSettingInitial());

  Future<void> fetchProductionSettingsByMonthYear(int month, int year) async {
    emit(GetProductionSettingLoading());
    try {
      final settings = await repository.getProductionSettingsByMonthYear(
        month,
        year,
      );
      emit(GetProductionSettingLoaded(settings));
    } catch (e) {
      emit(GetProductionSettingError(e.toString()));
    }
  }
}
