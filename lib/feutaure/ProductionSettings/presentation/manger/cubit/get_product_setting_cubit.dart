// lib/features/production_settings/presentation/cubit/production_settings_cubit.dart
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/get_product_setting_state.dart';
import 'package:tcp212/feutaure/ProductionSettings/repo/production_settings_repo.dart';

class ProductionSettingsCubit extends Cubit<ProductionSettingsState> {
  final ProductionSettingsRepo repository;

  ProductionSettingsCubit({required this.repository})
    : super(ProductionSettingsInitial());

  Future<void> fetchProductionSettings() async {
    emit(ProductionSettingsLoading());
    try {
      final settings = await repository
          .getProductionSettings(); // Direct call to repository
      emit(ProductionSettingsLoaded(settings: settings));
    } on ServerException catch (e) {
      emit(ProductionSettingsError(message: e.message));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(ProductionSettingsError(message: errorMessage));
    } catch (error) {
      emit(ProductionSettingsError(message: error.toString()));
    }
  }
}
