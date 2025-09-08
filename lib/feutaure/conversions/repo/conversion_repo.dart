import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/conversions/data/model/conversions_model.dart';

class ConversionsRepoImpl {
  final ApiService _apiService;

  ConversionsRepoImpl(this._apiService);

  Future<List<ConversionModel>> getAllConversions() async {
    try {
      final response = await _apiService.get('conversions');
      if (response.data != null && response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((item) => ConversionModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في جلب التحويلات: $e');
    }
  }

  Future<List<ConversionModel>> getConversionsByProductBatch(
    int productBatchId,
  ) async {
    try {
      final response = await _apiService.get(
        'conversions/by-product-batch/$productBatchId',
      );
      if (response.data != null && response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((item) => ConversionModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في جلب التحويلات لدفعة المنتج: $e');
    }
  }
}
