import 'package:flutter/material.dart';
import 'package:tcp212/feutaure/allUsers/data/model/user_model.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserModel> users;
  UsersLoaded(this.users);
}

class UsersError extends UsersState {
  final String errorMessage;
  UsersError(this.errorMessage);
}

class UserActivationChanging extends UsersState {
  final int userId;
  UserActivationChanging(this.userId); // لتحديد أي مستخدم يتم تغيير حالته
}

class UserActivationChanged extends UsersState {
  final int userId;
  final bool isActive;
  final String message;
  UserActivationChanged(this.userId, this.isActive, this.message);
}

class UserActivationChangeFailed extends UsersState {
  final int userId; // لتحديد أي مستخدم فشل تغيير حالته
  final String errorMessage;
  UserActivationChangeFailed(this.userId, this.errorMessage);
}

class UserUpdating extends UsersState {
  final int userId;
  UserUpdating(this.userId);
}

class UserUpdated extends UsersState {
  final UserModel updatedUser;
  final String message;
  UserUpdated(this.updatedUser, this.message);
}

class UserUpdateFailed extends UsersState {
  final int userId;
  final String errorMessage;
  UserUpdateFailed(this.userId, this.errorMessage);
}

class UserProfileLoading
    extends UsersState {} // لتجنب الالتباس مع UsersLoading العامة

class UserProfileLoaded extends UsersState {
  final UserModel user;
  UserProfileLoaded(this.user);
}

class UserProfileError extends UsersState {
  final String errorMessage;
  UserProfileError(this.errorMessage);
}

class UserDeleting extends UsersState {
  final int userId;
  UserDeleting(this.userId); // لتحديد أي مستخدم يتم حذفه
}

class UserDeleted extends UsersState {
  final int userId;
  final String message;
  UserDeleted(this.userId, this.message);
}

class UserDeleteFailed extends UsersState {
  final int userId; // لتحديد أي مستخدم فشل حذفه
  final String errorMessage;
  UserDeleteFailed(this.userId, this.errorMessage);
}
