// feutaure/notification/cubit/notifications_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/feutaure/notification/presentation/manger/notifications_state.dart';
import 'package:tcp212/feutaure/notification/repo/notifications_repo_impl.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;

  NotificationsCubit(this.notificationsRepo) : super(NotificationsInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    try {
      final notifications = await notificationsRepo.getNotifications();
      emit(NotificationsSuccess(notifications));
    } catch (e) {
      emit(NotificationsFailure(e.toString()));
    }
  }

  Future<void> markNotificationAsReadAndRefresh(String id) async {
    emit(NotificationsLoading());
    try {
      await notificationsRepo.markNotificationAsRead(id);
      final notifications = await notificationsRepo.getNotifications();
      emit(NotificationsSuccess(notifications));
    } catch (e) {
      emit(NotificationsFailure(e.toString()));
    }
  }

  Future<void> markAllNotificationsAsReadAndRefresh() async {
    emit(NotificationsLoading());
    try {
      await notificationsRepo.markAllNotificationsAsRead();
      final notifications = await notificationsRepo.getNotifications();
      emit(NotificationsSuccess(notifications));
    } catch (e) {
      emit(NotificationsFailure(e.toString()));
    }
  }
}
