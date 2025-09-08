// raw_material_batch_repository.dart

import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/data/batch_raw_material_model.dart';

class RawMaterialBatchRepository {
  final ApiService apiService;

  RawMaterialBatchRepository(this.apiService);

  Future<String> addRawMaterialBatch(Map<String, dynamic> batchData) async {
    try {
      final response = await apiService.post('raw-material-batches', batchData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('message')) {
          return response.data['message'];
        } else {
          return 'تمت إضافة دفعة المادة الخام بنجاح!';
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: "فشل إضافة دفعة المادة الخام: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<RawMaterialBatchModel>> fetchRawMaterialBatches() async {
    try {
      // إرسال طلب GET إلى مسار API لجلب الدفعات
      // بافتراض أن المسار هو 'raw-material-batches'
      final response = await apiService.get(
        'raw-material-batches',
      ); // افترضت هذا المسار

      // التحقق من رمز الحالة الناجح
      if (response.statusCode == 200) {
        // التحقق من أن البيانات موجودة وأنها قائمة
        if (response.data != null && response.data['data'] is List) {
          // تحويل قائمة الخرائط JSON إلى قائمة من RawMaterialBatchModel
          return (response.data['data'] as List)
              .map(
                (item) => RawMaterialBatchModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        } else {
          // إذا كانت البيانات غير متوقعة، ارمِ استثناء
          throw Exception('Received unexpected data format from API');
        }
      } else {
        // إذا كان رمز الحالة ليس 200، ارمِ DioException من نوع badResponse
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: "فشل جلب دفعات المواد الخام: ${response.statusCode}",
        );
      }
    } on DioException {
      // إعادة رمي DioException الأصلي للسماح للـ Cubit بالتقاطه ومعالجته بواسطة ErrorHandler
      rethrow;
    } catch (e) {
      throw Exception(
        'حدث خطأ غير متوقع في جلب دفعات المواد الخام: ${e.toString()}',
      );
    }
  }

  Future<void> updateRawMaterialBatch(
    int batchId,
    Map<String, dynamic> batchData,
  ) async {
    try {
      final response = await apiService.update(
        'raw-material-batches/$batchId', // Assuming this is the correct endpoint for updating a specific batch
        data: batchData,
      );

      if (response.statusCode == 200) {
        // Handle successful update
        // You might want to parse the response if the backend returns updated data
        print('Raw material batch updated successfully: ${response.data}');
      } else {
        // Handle non-200 status codes
        throw Exception(
          'Failed to update raw material batch: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      // التقاط أي استثناءات أخرى غير متوقعة (ليست DioException)
      throw Exception(
        'حدث خطأ غير متوقع في جلب دفعات المواد الخام: ${e.toString()}',
      );
    }
  }

  Future<String> deleatBatchRawMaterial(int id) async {
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

  Future<List<RawMaterialBatch>> getAllBatch({
    required int rawMaterialId,
  }) async {
    try {
      final response = await apiService.get('by-raw-material/$rawMaterialId');
      final data = response.data['data'] as List;
      final batches = data
          .map((json) => RawMaterialBatch.fromJson(json))
          .toList();
      return batches;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class RawMaterialBatch {
  final int rawMaterialBatchId;
  final int userId;
  final int rawMaterialId;
  final double quantityIn;
  final double quantityOut;
  final double quantityRemaining;
  final double realCost;
  final String paymentMethod;
  final String supplier;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  RawMaterialBatch({
    required this.rawMaterialBatchId,
    required this.userId,
    required this.rawMaterialId,
    required this.quantityIn,
    required this.quantityOut,
    required this.quantityRemaining,
    required this.realCost,
    required this.paymentMethod,
    required this.supplier,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RawMaterialBatch.fromJson(Map<String, dynamic> json) {
    return RawMaterialBatch(
      rawMaterialBatchId: json['raw_material_batch_id'],
      userId: json['user_id'],
      rawMaterialId: json['raw_material_id'],
      quantityIn: double.parse(json['quantity_in']),
      quantityOut: double.parse(json['quantity_out']),
      quantityRemaining: double.parse(json['quantity_remaining']),
      realCost: double.parse(json['real_cost']),
      paymentMethod: json['payment_method'],
      supplier: json['supplier'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
