// raw_material_batch_state.dart

import 'package:equatable/equatable.dart';

// تعريف الفئة الأساسية لحالات دفعة المواد الخام
abstract class AddRawMaterialBatchState extends Equatable {
  const AddRawMaterialBatchState();

  @override
  List<Object> get props => [];
}

// الحالة الأولية لدفعة المواد الخام
class AddRawMaterialBatchInitial extends AddRawMaterialBatchState {}

// حالة التحميل عند إضافة دفعة جديدة
class AddRawMaterialBatchLoading extends AddRawMaterialBatchState {}

// حالة النجاح عند إضافة دفعة جديدة بنجاح
class AddRawMaterialBatchSuccess extends AddRawMaterialBatchState {
  final String message; // رسالة النجاح من الخادم
  const AddRawMaterialBatchSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddRawMaterialBatchError extends AddRawMaterialBatchState {
  final String errorMessage; // رسالة الخطأ التي تم معالجتها بواسطة ErrorHandler
  const AddRawMaterialBatchError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
