// raw_material_batches_list_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:tcp212/core/util/error/error_handling.dart'; // تأكد من المسار الصحيح لـ ErrorHandler
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_get/get_batch_raw_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart'; // استيراد الـ States الجديدة

class RawMaterialBatchesListCubit extends Cubit<RawMaterialBatchesListState> {
  final RawMaterialBatchRepository rawMaterialBatchesListRepository;

  RawMaterialBatchesListCubit(this.rawMaterialBatchesListRepository)
    : super(RawMaterialBatchesListInitial());

  /// دالة لجلب قائمة دفعات المواد الخام.
  Future<void> fetchRawMaterialBatches() async {
    emit(RawMaterialBatchesListLoading()); // إصدار حالة التحميل

    try {
      // استدعاء دالة جلب الدفعات من الـ Repository
      final batches = await rawMaterialBatchesListRepository
          .fetchRawMaterialBatches();
      emit(
        RawMaterialBatchesListLoaded(batches),
      ); // إصدار حالة النجاح مع قائمة الدفعات
    } on DioException catch (e) {
      // التقاط DioException ومعالجته باستخدام ErrorHandler
      final errorMessage = ErrorHandler.handleDioError(e);
      emit(
        RawMaterialBatchesListError(errorMessage),
      ); // إصدار حالة الخطأ مع الرسالة المعالجة
    } catch (e) {
      // التقاط أي استثناءات أخرى غير متوقعة (ليست DioException)
      emit(
        RawMaterialBatchesListError("حدث خطأ غير متوقع: ${e.toString()}"),
      ); // إصدار حالة الخطأ العامة
    }
  }
}
