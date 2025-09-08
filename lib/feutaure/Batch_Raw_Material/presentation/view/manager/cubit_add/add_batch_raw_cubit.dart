// raw_material_batch_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:tcp212/core/util/error/error_handling.dart'; // تأكد من المسار الصحيح لـ ErrorHandler
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart'; // تأكد من المسار الصحيح لـ States

class AddRawMaterialBatchCubit extends Cubit<AddRawMaterialBatchState> {
  final RawMaterialBatchRepository rawMaterialBatchRepository;

  AddRawMaterialBatchCubit(this.rawMaterialBatchRepository)
    : super(AddRawMaterialBatchInitial());

  Future<void> addRawMaterialBatch(Map<String, dynamic> batchData) async {
    emit(AddRawMaterialBatchLoading()); // إصدار حالة التحميل

    try {
      final message = await rawMaterialBatchRepository.addRawMaterialBatch(
        batchData,
      );
      emit(AddRawMaterialBatchSuccess(message)); // إصدار حالة النجاح مع الرسالة
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(AddRawMaterialBatchError(errorMessage));
    } catch (error) {
      emit(
        AddRawMaterialBatchError(
          error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
