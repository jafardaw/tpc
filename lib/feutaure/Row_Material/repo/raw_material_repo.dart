import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/Row_Material/data/add_raw_material_model.dart';
import 'package:tcp212/feutaure/Row_Material/data/get_raw_material_model.dart';

class RawMaterialRepository {
  final ApiService apiService;

  RawMaterialRepository({required this.apiService});

  Future<String> addRawMaterial(RawMaterial rawMaterial) async {
    try {
      final response = await apiService.post(
        'raw-materials/',
        rawMaterial.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('message')) {
          return response.data['message'].toString();
        } else {
          return 'تمت إضافة المادة الخام بنجاح!';
        }
      } else {
        throw Exception('فشل في الإضافة: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? e.message ?? 'فشل الاتصال بالخادم';
      throw Exception('فشل إضافة المادة الخام: $message');
    } catch (e) {
      // ✅ هنا نتحقق إن كان الخطأ نفسه Exception فيه رسالة، نستخدمها كما هي
      if (e is Exception) {
        rethrow; // نعيد نفس الاستثناء بدون أي إضافات
      } else {
        throw Exception('حدث خطأ غير متوقع');
      }
    }
  }

  Future<List<GetRawMaterialModel>> getRawMaterials() async {
    try {
      final response = await apiService.get(
        'raw-materials/', // افترض أن هذا هو endpoint لجلب القائمة
      );

      if (response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('data')) {
          final List<dynamic> rawMaterialsJson = response.data['data'];
          // تحويل كل عنصر JSON إلى كائن RawMaterial
          return rawMaterialsJson
              .map(
                (json) =>
                    GetRawMaterialModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        } else {
          throw Exception('هيكل استجابة API غير صالح: لا يوجد حقل "data"');
        }
      } else {
        throw Exception('فشل في جلب المواد الخام: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMessage = ErrorHandler.handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(
        'حدث خطأ غير متوقع أثناء جلب المواد الخام: ${e.toString()}',
      );
    }
  }

  Future<List<GetRawMaterialModel>> searchRawMaterials({
    String? name,
    String? description,
    String? status,
    double? minPrice,
    double? maxPrice,
    double? minStockAlert,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (name != null && name.isNotEmpty) queryParameters['name'] = name;
    if (description != null && description.isNotEmpty) {
      queryParameters['description'] = description;
    }
    if (status != null && status.isNotEmpty) queryParameters['status'] = status;
    if (minPrice != null) queryParameters['price_min'] = minPrice;
    if (maxPrice != null) queryParameters['price_max'] = maxPrice;
    if (minStockAlert != null) {
      queryParameters['minimum_stock_alert'] = minStockAlert;
    }

    log('wqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq$queryParameters');

    final response = await apiService.get(
      'search/raw-materials',
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => GetRawMaterialModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search raw materials: ${response.statusCode}');
    }
  }

  Future<String> updateRawMaterial(RawMaterial rawMaterial, int id) async {
    try {
      final response = await apiService.update(
        'raw-materials/$id',
        data: rawMaterial.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('message')) {
          return response.data['message'].toString();
        } else {
          return 'تمت تعديل المادة الخام بنجاح!';
        }
      } else {
        throw Exception('فشل في التعديل: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> deleatRawMaterial(int id) async {
    try {
      final response = await apiService.delete('raw-materials/$id');

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('message')) {
          return response.data['message'].toString();
        } else {
          return 'تمت حذف المادة الخام بنجاح!';
        }
      } else {
        throw Exception(' ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
