// lib/features/products_count/data/repositories/products_count_repository_impl.dart
import 'package:dio/dio.dart';

import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/feutaure/counts/data/model/products_count_model.dart';
import 'package:tcp212/feutaure/counts/data/model/row_count_model.dart';

class ProductsCountRepositoryImpl {
  final ApiService apiService;

  ProductsCountRepositoryImpl({required this.apiService});

  Future<ProductsCountModel> getProductsCount() async {
    try {
      final response = await apiService.get('products/count');
      return ProductsCountModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get products count: ${e.message}');
    }
  }

  Future<RawMaterialsCountModel> getRawMaterialsCount() async {
    try {
      final response = await apiService.get('raw-materials/count');
      return RawMaterialsCountModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get raw materials count: ${e.message}');
    }
  }
}
