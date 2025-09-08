import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/simi_products/data/model/simi_product_model.dart';

class SemiFinishedProductsRepositoryImpl {
  final ApiService apiService;

  SemiFinishedProductsRepositoryImpl(this.apiService);

  Future<List<SimiProductModel>> getSemiFinishedProducts() async {
    try {
      final response = await apiService.get('products/semi-finished-products');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SimiProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load semi-finished products');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<int> getProductsCount() async {
    try {
      final response = await apiService.get('products/count');
      if (response.statusCode == 200) {
        // The API returns a simple integer, so we cast it directly.
        final int count = response.data;
        return count;
      } else {
        throw Exception('Failed to load products count');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
