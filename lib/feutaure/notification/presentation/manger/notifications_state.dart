import 'package:equatable/equatable.dart';
import 'package:tcp212/feutaure/notification/data/model/notification_data_model.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final List<NotificationModel> notifications;

  const NotificationsSuccess(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationsFailure extends NotificationsState {
  final String errorMessage;

  const NotificationsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
