import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/add_production_setting_model.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_state.dart';
import 'package:tcp212/feutaure/ProductionSettings/repo/production_settings_repo.dart';

class AddProductionSettingsCubit extends Cubit<AddProductionSettingState> {
  final ProductionSettingsRepo repository;

  AddProductionSettingsCubit({required this.repository})
    : super(AddProductionSettingsInitial());

  Future<void> addProductionSettings({
    required double totalProduction,
    required String type,
    required double profitRatio,
    required int month,
    required int year,
    String? notes,
  }) async {
    emit(AddProductionSettingsLoading());
    try {
      final settings = AddProductionSettingsModel(
        totalProduction: totalProduction,
        type: type,
        profitRatio: profitRatio,
        month: month,
        year: year,
        notes: notes,
      );
      await repository.addProductionSettings(settings);
      emit(AddProductionSettingsSuccess());
    } catch (e) {
      emit(AddProductionSettingsFailure(e.toString()));
    }
  }

  Future<void> updateProductionSettings({
    required int id,
    required double totalProduction,
    required double profitRatio,
    String? notes,
  }) async {
    emit(ProductionSettingsUpdating());
    try {
      await repository.updateProductionSettings(
        id,
        totalProduction,
        profitRatio,
        notes,
      );
      emit(ProductionSettingsUpdated());
    } catch (e) {
      emit(ProductionSettingsUpdateFailed(e.toString()));
    }
  }

  Future<void> deleteProductionSettings(int id) async {
    emit(ProductionSettingsDeleting());
    try {
      await repository.deleteProductionSettings(id);
      emit(ProductionSettingsDeleted());
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(ProductionSettingsDeleteFailed(errorMessage));
    } catch (error) {
      emit(ProductionSettingsDeleteFailed(error.toString()));
    }
  }
}
