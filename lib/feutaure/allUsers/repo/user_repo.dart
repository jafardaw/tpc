import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/allUsers/data/model/user_model.dart';

class UserRepoImpl {
  final ApiService _apiService;

  UserRepoImpl(this._apiService);

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _apiService.get('showAllUsers');
      if (response.data != null && response.data['users'] is List) {
        return (response.data['users'] as List)
            .map((item) => UserModel.fromJson(item))
            .toList();
      } else {
        return []; // إرجاع قائمة فارغة إذا لم تكن هناك بيانات أو كانت غير صحيحة
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('Failed to fetch all users: $e');
    }
  }

  Future<Map<String, dynamic>> changeUserActivationStatus(int userId) async {
    try {
      final response = await _apiService.update(
        'admin/change-user-activation/$userId',
        data: {},
      );
      return response.data as Map<String, dynamic>; // ارجع الرد كاملاً
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('Failed to change user activation status: $e');
    }
  }

  Future<UserModel> updateUser(
    int userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _apiService.update(
        'user/update/$userId', // المسار مع الـ ID
        data: userData,
      );
      if (response.data != null && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Invalid response format for user update');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<UserModel> getUserById(int userId) async {
    try {
      final response = await _apiService.get(
        'user/show/$userId',
      ); // استخدام المسار الجديد
      // تحقق من أن بيانات المستخدم موجودة تحت مفتاح 'user' في الـ response
      if (response.data != null && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Invalid response format: User data not found.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في جلب بيانات المستخدم: $e');
    }
  }

  Future<UserModel> updateProfile(
    int userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _apiService.update(
        'user/update/$userId', // المسار مع الـ ID
        data:
            userData, // البيانات التي تم تمريرها (بما في ذلك كلمة المرور إذا وجدت)
      );
      if (response.data != null && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('تنسيق استجابة غير صالح لتحديث المستخدم');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في تحديث المستخدم: $e');
    }
  }

  Future<Map<String, dynamic>> deleteUser(int userId) async {
    // <--- تطبيق الدالة
    try {
      final response = await _apiService.delete(
        'user/delete/$userId',
      ); // استخدام دالة delete
      return response.data
          as Map<String, dynamic>; // عادةً ما تعود رسالة وstatus
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في حذف المستخدم: $e');
    }
  }
}
