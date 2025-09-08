import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart'; // Ensure this path is correct

class UpdateBatchRawMaterialCubit extends Cubit<UpdateBatchRawMaterialState> {
  final RawMaterialBatchRepository _repository;

  UpdateBatchRawMaterialCubit(this._repository)
    : super(UpdateBatchRawMaterialInitial());

  Future<void> updateRawMaterialBatch(
    int batchId,
    Map<String, dynamic> batchData,
  ) async {
    emit(UpdateBatchRawMaterialLoading());
    try {
      await _repository.updateRawMaterialBatch(batchId, batchData);
      emit(
        UpdateBatchRawMaterialSuccess(message: 'Batch updated successfully!'),
      );
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(UpdateBatchRawMaterialError(errorMessage: errorMessage));
    } catch (error) {
      emit(
        UpdateBatchRawMaterialError(
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> deleatBatchRawMaterial(int id) async {
    emit(DeleatBatchRawMaterialLoading());
    try {
      final message = await _repository.deleatBatchRawMaterial(id);
      emit(DeleatBatchRawMaterialSuccess(message));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(DeleatBatchRawMaterialError(errorMessage));
    } catch (error) {
      emit(
        DeleatBatchRawMaterialError(
          error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
