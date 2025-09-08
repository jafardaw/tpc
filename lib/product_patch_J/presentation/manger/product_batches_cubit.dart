// lib/feutaure/product_batch/presentation/manger/product_batches_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/product_patch_J/data/model/product_batch_j_model.dart';
import 'package:tcp212/product_patch_J/data/model/product_batch_update_j_model.dart';
import 'package:tcp212/product_patch_J/presentation/manger/product_batches_state.dart';
import 'package:tcp212/product_patch_J/repo/product_batches_j_repo.dart';

class ProductBatchesJCubit extends Cubit<ProductBatchesJState> {
  final ProductBatchesJRepo productBatchesRepo;

  ProductBatchesJCubit(this.productBatchesRepo)
    : super(ProductBatchesJInitial());

  Future<void> createProductBatch({
    required int productId,
    required int quantityIn,
    String? notes,
    required String status,
    int? reproductionCount,
  }) async {
    emit(ProductBatchesJLoading());
    try {
      final batchData = CreateProductBatchJModel(
        productId: productId,
        quantityIn: quantityIn,
        notes: notes,
        status: status,
        reproductionCount: reproductionCount,
      );
      await productBatchesRepo.createProductBatch(batchData);
      emit(ProductBatchesJSuccess());
    } catch (e) {
      emit(ProductBatchesJFailure(e.toString()));
    }
  }

  Future<void> updateProductBatch({
    required int batchId,
    required int quantityIn,
    String? notes,
    required String status,
    int? reproductionCount,
  }) async {
    emit(ProductBatchesJLoading());
    try {
      final batchData = UpdateProductBatcJhModel(
        quantityIn: quantityIn,
        notes: notes,
        status: status,
        reproductionCount: reproductionCount,
      );
      await productBatchesRepo.updateProductBatch(batchId, batchData);
      emit(ProductBatchesJSuccess());
    } catch (e) {
      emit(ProductBatchesJFailure(e.toString()));
    }
  }
}
