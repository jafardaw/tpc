import 'package:bloc/bloc.dart';
import 'package:tcp212/feutaure/allUsers/presentation/manger/cubit/user_state.dart';
import 'package:tcp212/feutaure/allUsers/repo/user_repo.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepoImpl repository;

  UsersCubit({required this.repository}) : super(UsersInitial());

  Future<void> fetchAllUsers() async {
    emit(UsersLoading());
    try {
      final users = await repository.getAllUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> changeUserActivationStatus(int userId) async {
    emit(UserActivationChanging(userId));

    try {
      final response = await repository.changeUserActivationStatus(userId);
      final bool isActive = response['is_active'] as bool;
      final String message = response['message'] as String;

      emit(UserActivationChanged(userId, isActive, message));

      await fetchAllUsers();
    } catch (e) {
      emit(UserActivationChangeFailed(userId, e.toString()));
      await fetchAllUsers();
    }
  }

  Future<void> updateUser({
    required int userId,
    required String name,
    required String email,
    required String phone,
    required String userRole,
    required bool flag,
  }) async {
    emit(UserUpdating(userId));
    try {
      final Map<String, dynamic> userData = {
        "name": name,
        "email": email,
        "phone": phone,
        "user_role": userRole,
        "flag": flag,
      };
      final updatedUser = await repository.updateUser(userId, userData);
      emit(UserUpdated(updatedUser, "تم تحديث المستخدم بنجاح."));
      // بعد التحديث، قد تحتاج لإعادة جلب كل المستخدمين لتحديث القائمة الرئيسية
      await fetchAllUsers();
    } catch (e) {
      emit(UserUpdateFailed(userId, e.toString()));
      // إذا فشل التحديث، قد تحتاج لإعادة جلب كل المستخدمين
      await fetchAllUsers();
    }
  }

  Future<void> fetchUserProfile(int userId) async {
    emit(UserProfileLoading()); // إصدار حالة تحميل خاصة بالبروفايل
    try {
      final user = await repository.getUserById(userId);
      emit(UserProfileLoaded(user));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String phone,
    String? password,
  }) async {
    emit(UserUpdating(userId));
    try {
      final Map<String, dynamic> userData = {
        "name": name,
        "email": email,
        "phone": phone,
      };
      if (password != null && password.isNotEmpty) {
        userData["password"] = password;
      }

      final updatedUser = await repository.updateUser(userId, userData);
      emit(UserUpdated(updatedUser, "تم تحديث المستخدم بنجاح."));
      await fetchAllUsers();
    } catch (e) {
      emit(UserUpdateFailed(userId, e.toString()));
      await fetchAllUsers();
    }
  }

  Future<void> deleteUser(int userId) async {
    emit(UserDeleting(userId)); // نخبر الـ UI بأن هذا المستخدم قيد الحذف

    try {
      final response = await repository.deleteUser(userId);
      final String message = response['message'] as String? ??
          'تم حذف المستخدم بنجاح.'; // رسالة افتراضية

      emit(UserDeleted(userId, message));

      // الأهم: بعد حذف المستخدم بنجاح، أعد جلب قائمة المستخدمين
      // لتعكس التغيير في الواجهة (إزالة المستخدم المحذوف).
      await fetchAllUsers();
    } catch (e) {
      emit(UserDeleteFailed(userId, e.toString()));
      // إذا حدث خطأ، قد ترغب أيضاً في إعادة جلب القائمة لضمان التناسق
      await fetchAllUsers(); // هذا سيقوم بإعادة تعيين الحالة إلى UsersLoading ثم UsersLoaded/UsersError
    }
  }
}
