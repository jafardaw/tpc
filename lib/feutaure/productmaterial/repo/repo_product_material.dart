import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/productmaterial/data/product_material_model.dart';

class ProductMaterialsRepo {
  final ApiService _apiService;

  ProductMaterialsRepo(this._apiService);

  Future<List<ProductMaterialRelationship>> fetchProductMaterials() async {
    try {
      final response = await _apiService.get(
        'product-materials',
      ); // نقطة النهاية (endpoint) الجديدة
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'];
        return jsonList
            .map((json) => ProductMaterialRelationship.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load product materials: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<ProductMaterialRelationship>> fetchProductMaterialsByid({
    required int id,
  }) async {
    try {
      final response = await _apiService.get(
        'product-materials/by-product/$id',
      ); // نقطة النهاية (endpoint) الجديدة
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'];
        return jsonList
            .map((json) => ProductMaterialRelationship.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load product materials: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> deleteProductMaterial(int productMaterialId) async {
    try {
      final response = await _apiService.delete(
        'product-rawmaterial/$productMaterialId',
      );
      if (response.statusCode == 200) {
        print(
          'Product material relationship deleted successfully: $productMaterialId',
        );
      } else {
        throw Exception(
          'Failed to delete product material relationship: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
