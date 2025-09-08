// lib/feutaure/product_batch/repo/product_batches_repo.dart

import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/product_patch_J/data/model/product_batch_j_model.dart';
import 'package:tcp212/product_patch_J/data/model/product_batch_update_j_model.dart';

abstract class ProductBatchesJRepo {
  Future<void> createProductBatch(CreateProductBatchJModel batchData);
  Future<void> updateProductBatch(
    int batchId,
    UpdateProductBatcJhModel batchData,
  );
}
// lib/feutaure/product_batch/repo/product_batches_repo_impl.dart

class ProductBatchesJRepoImpl implements ProductBatchesJRepo {
  final ApiService apiService;

  ProductBatchesJRepoImpl(this.apiService);

  @override
  Future<void> createProductBatch(CreateProductBatchJModel batchData) async {
    try {
      await apiService.post('product-batches', batchData.toJson());
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'حدث خطأ غير معروف');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع.');
    }
  }

  @override
  Future<void> updateProductBatch(
    int batchId,
    UpdateProductBatcJhModel batchData,
  ) async {
    try {
      await apiService.update(
        'product-batches/$batchId',
        data: batchData.toJson(),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'حدث خطأ غير معروف');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع.');
    }
  }
}
