import 'package:tcp212/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart';

abstract class AllBatchRawMaterialState {}

class AllBatchRawMaterialInitial extends AllBatchRawMaterialState {}

class AllBatchRawMaterialLoading extends AllBatchRawMaterialState {}

class AllBatchRawMaterialSuccess extends AllBatchRawMaterialState {
  final List<RawMaterialBatch> batches;
  AllBatchRawMaterialSuccess({required this.batches});
}

class AllBatchRawMaterialFailure extends AllBatchRawMaterialState {
  final String errMessage;
  AllBatchRawMaterialFailure({required this.errMessage});
}
