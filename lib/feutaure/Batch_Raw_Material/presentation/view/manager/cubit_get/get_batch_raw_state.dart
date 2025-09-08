// raw_material_batches_list_state.dart

import 'package:equatable/equatable.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/data/batch_raw_material_model.dart'; // استيراد نموذج دفعة المواد الخام

// تعريف الفئة الأساسية لحالات قائمة دفعات المواد الخام
abstract class RawMaterialBatchesListState extends Equatable {
  const RawMaterialBatchesListState();

  @override
  List<Object> get props => [];
}

// الحالة الأولية لقائمة دفعات المواد الخام
class RawMaterialBatchesListInitial extends RawMaterialBatchesListState {}

// حالة التحميل عند جلب قائمة الدفعات
class RawMaterialBatchesListLoading extends RawMaterialBatchesListState {}

// حالة النجاح عند جلب قائمة الدفعات بنجاح
class RawMaterialBatchesListLoaded extends RawMaterialBatchesListState {
  final List<RawMaterialBatchModel> batches; // قائمة الدفعات التي تم جلبها

  const RawMaterialBatchesListLoaded(this.batches);

  @override
  List<Object> get props => [batches];
}

// حالة الخطأ عند فشل جلب قائمة الدفعات
class RawMaterialBatchesListError extends RawMaterialBatchesListState {
  final String errorMessage; // رسالة الخطأ التي تم معالجتها بواسطة ErrorHandler

  const RawMaterialBatchesListError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
