// lib/features/production_settings/data/repositories/production_settings_repo.dart
import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/add_production_setting_model.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/entities/production_setting.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/production_setting_model.dart';

class ProductionSettingsRepo {
  final ApiService apiService;

  ProductionSettingsRepo(this.apiService);

  Future<List<ProductionSetting>> getProductionSettings() async {
    try {
      final response = await apiService.get('production-settings');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<ProductionSetting> settings = data
            .map((json) => ProductionSettingModel.fromJson(json))
            .toList();
        return settings;
      } else {
        throw ServerException(
          'Failed to load production settings: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'A network error occurred.');
    } catch (e) {
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> addProductionSettings(
    AddProductionSettingsModel settings,
  ) async {
    try {
      await apiService.post(
        'production-settings', // Endpoint for production settings
        settings.toJson(),
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('Failed to add production settings: $e');
    }
  }

  Future<void> updateProductionSettings(
    int id,
    double totalProduction,
    double profitRatio,
    String? notes,
  ) async {
    try {
      final Map<String, dynamic> data = {
        "total_production": totalProduction,
        "profit_ratio": profitRatio,
      };
      if (notes != null) {
        data["notes"] = notes;
      }

      await apiService.update('production-settings/$id', data: data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update production settings: $e');
    }
  }

  Future<void> deleteProductionSettings(int id) async {
    // <--- تطبيق الدالة
    try {
      await apiService.delete('production-settings/$id');
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete production setting: $e');
    }
  }

  Future<List<ProductionSettingModel>> getProductionSettingsByMonthYear(
    int month,
    int year,
  ) async {
    try {
      final response = await apiService.get(
        'by-month/production-settings',
        queryParameters: {'month': month, 'year': year},
      );
      // تحقق من أن البيانات موجودة وفاتية
      if (response.data != null && response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((item) => ProductionSettingModel.fromJson(item))
            .toList();
      } else {
        return []; // إرجاع قائمة فارغة إذا لم تكن هناك بيانات أو كانت غير صحيحة
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception(
        'Failed to fetch production settings by month and year: $e',
      );
    }
  }
}

// Define custom exceptions to be thrown by the repository
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

// lib/features/production_settings/data/model/production_setting_model.dart
// (ملاحظة: المسار في الكود الذي أرسلته كان 'feutaure/ProductionSettings/data/model/production_setting_model.dart'
//  لكنني سأفترض أنه يجب أن يكون 'features/production_settings/data/model/production_setting_model.dart' ليتوافق مع باقي بنية المشروع.)
