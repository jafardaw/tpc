// lib/feature/raw_materials/cubit/all_batch_raw_material_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_allbatch/getallbatchforrawmaterial_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart';

class AllBatchRawMaterialCubit extends Cubit<AllBatchRawMaterialState> {
  final RawMaterialBatchRepository rawMaterialRepo;
  AllBatchRawMaterialCubit({required this.rawMaterialRepo})
    : super(AllBatchRawMaterialInitial());

  Future<void> getAllBatch({required int rawMaterialId}) async {
    emit(AllBatchRawMaterialLoading());
    try {
      final batches = await rawMaterialRepo.getAllBatch(
        rawMaterialId: rawMaterialId,
      );
      emit(AllBatchRawMaterialSuccess(batches: batches));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(AllBatchRawMaterialFailure(errMessage: errorMessage));
    } catch (error) {
      emit(
        AllBatchRawMaterialFailure(
          errMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
