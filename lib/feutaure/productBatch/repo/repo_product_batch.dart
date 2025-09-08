import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/feutaure/productBatch/data/product_batch_by_id_model.dart';
import 'package:tcp212/feutaure/productBatch/data/product_batch_model.dart';
import 'package:tcp212/core/util/error/error_handling.dart';

class ProductBatchRepo {
  final ApiService apiService;

  ProductBatchRepo({required this.apiService});

  Future<List<ProductBatch>> fetchAllProductBatches() async {
    try {
      final response = await apiService.get('product-batches');
      final productBatchResponse = ProductBatchResponse.fromJson(response.data);
      return productBatchResponse.data;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<ProductBatchResponseByid> fetchProductBatchesById(int id) async {
    try {
      final response = await apiService.get('product-batches/by-product/$id');
      return ProductBatchResponseByid.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
