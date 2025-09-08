import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/feutaure/profit-loss-report/data/model/sub_profit-loss-report_model.dart';
import '../../../../core/util/error/error_handling.dart';

class DamagedMaterialRepositoryImp {
  final ApiService _apiService;

  DamagedMaterialRepositoryImp(this._apiService);

  Future<List<DamagedMaterialProfitLossReportModel>>
  getDamagedMaterials() async {
    try {
      final response = await _apiService.get('damaged-materials');

      if (response.data != null && response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((item) => DamagedMaterialProfitLossReportModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في جلب المواد التالفة: $e');
    }
  }

  Future<void> deleteDamagedMaterial(int damagedMaterialId) async {
    try {
      await _apiService.delete('damaged-materials/$damagedMaterialId');
      // API returns 200 status with 'message' on success, no 'data'
    } on DioException catch (e) {
      // Handle specific 404 messages from your API
      if (e.response?.statusCode == 404) {
        if (e.response?.data != null && e.response?.data['message'] != null) {
          // Re-throw with the specific message for UI to display
          throw Exception(e.response?.data['message']);
        }
      }
      // For other DioErrors, use the general error handler
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      // Catch any other unexpected errors
      throw Exception('فشل في حذف المادة التالفة رقم $damagedMaterialId: $e');
    }
  }

  Future<DamagedMaterialProfitLossReportModel> createDamagedMaterial({
    int?
    rawMaterialBatchId, // يمكن أن يكون null إذا كانت product_batch_id موجودة
    int?
    productBatchId, // يمكن أن يكون null إذا كانت raw_material_batch_id موجودة
    required double quantity,
  }) async {
    final Map<String, dynamic> data = {'quantity': quantity};

    if (rawMaterialBatchId != null) {
      data['raw_material_batch_id'] = rawMaterialBatchId;
    }
    if (productBatchId != null) {
      data['product_batch_id'] = productBatchId;
    }

    try {
      final response = await _apiService.post('damaged-materials', data);

      if (response.data != null && response.data['data'] != null) {
        return DamagedMaterialProfitLossReportModel.fromJson(
          response.data['data'],
        );
      } else {
        throw Exception(
          'الاستجابة لا تحتوي على بيانات للمادة التالفة التي تم إنشاؤها.',
        );
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في إنشاء مادة تالفة جديدة: $e');
    }
  }

  Future<DamagedMaterialProfitLossReportModel> updateDamagedMaterial(
    int damagedMaterialId, {
    required double quantity,
    String? notes,
  }) async {
    final Map<String, dynamic> data = {'quantity': quantity};

    if (notes != null) {
      // Only add notes if provided (allow clearing by passing empty string)
      data['notes'] = notes;
    }

    try {
      final response = await _apiService.update(
        'damaged-materials/$damagedMaterialId',
        data: data,
      );

      if (response.data != null && response.data['data'] != null) {
        return DamagedMaterialProfitLossReportModel.fromJson(
          response.data['data'],
        );
      } else {
        throw Exception(
          'الاستجابة لا تحتوي على بيانات للمادة التالفة المحدثة.',
        );
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في تحديث المادة التالفة رقم $damagedMaterialId: $e');
    }
  }
}
