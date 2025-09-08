// feutaure/notification/repo/notifications_repo.dart

import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/feutaure/notification/data/model/notification_data_model.dart';

abstract class NotificationsRepo {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markNotificationAsRead(String id);
  Future<void> markAllNotificationsAsRead();
}

// feutaure/notification/repo/notifications_repo_impl.dart

class NotificationsRepoImpl implements NotificationsRepo {
  final ApiService apiService;

  NotificationsRepoImpl(this.apiService);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await apiService.get('notifications');
      final List<dynamic> notificationsJson =
          response.data['notifications']['data'];
      final notifications = notificationsJson
          .map((json) => NotificationModel.fromJson(json))
          .toList();
      return notifications;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'حدث خطأ غير معروف');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع.');
    }
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    try {
      await apiService.update('notifications/$id/read');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'حدث خطأ غير معروف');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع.');
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    try {
      await apiService.update('notifications/read-all');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'حدث خطأ غير معروف');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع.');
    }
  }
}
