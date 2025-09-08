// lib/cubit/Update_raw_material/Update_raw_material_cubit.dart
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/error/error_handling.dart';

import 'package:tcp212/feutaure/Row_Material/data/add_raw_material_model.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_state.dart';
import 'package:tcp212/feutaure/Row_Material/repo/raw_material_repo.dart';

class UpdateRawMaterialCubit extends Cubit<UpdateRawmaterialState> {
  final RawMaterialRepository rawMaterialRepository;

  UpdateRawMaterialCubit({required this.rawMaterialRepository})
    : super(UpdateRawMaterialInitial());

  Future<void> updateawMaterial(RawMaterial rawMaterial, int id) async {
    emit(UpdateRawMaterialLoading());
    try {
      final newRawMaterial = await rawMaterialRepository.updateRawMaterial(
        rawMaterial,
        id,
      );

      print('mohamamasdasdasd$newRawMaterial');
      emit(UpdateRawMaterialSuccess(newRawMaterial));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(UpdateRawMaterialError(errorMessage));
    } catch (error) {
      emit(
        UpdateRawMaterialError(
          error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> deleatRawMaterial(int id) async {
    emit(DeleatRawMaterialLoading());
    try {
      final message = await rawMaterialRepository.deleatRawMaterial(id);
      emit(DeleatRawMaterialSuccess(message));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(DeleatRawMaterialError(errorMessage));
    } catch (error) {
      emit(
        DeleatRawMaterialError(
          error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
