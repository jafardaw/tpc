import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/alert_dilog.dart'; // لتنبيهات الأخطاء
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/util/styles.dart';
import 'package:tcp212/core/widget/appar_widget,.dart'; // للـ AppBar المخصص
import 'package:tcp212/core/widget/cusrom_button_card.dart';
import 'package:tcp212/core/widget/error_widget_view.dart'; // لعرض أخطاء الجلب
import 'package:tcp212/feutaure/allUsers/data/model/user_model.dart';
import 'package:tcp212/feutaure/allUsers/presentation/manger/cubit/user_cubit.dart';
import 'package:tcp212/feutaure/allUsers/presentation/manger/cubit/user_state.dart';
import 'package:tcp212/feutaure/allUsers/presentation/user_view.dart';
import 'package:tcp212/feutaure/allUsers/presentation/view/edit_profile_screen.dart';
import 'package:tcp212/feutaure/allUsers/presentation/view/edit_user_screen.dart';
import 'package:tcp212/feutaure/allUsers/repo/user_repo.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final UserModel userModel;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.userModel,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UsersCubit _usersCubit;

  @override
  void initState() {
    super.initState();
    _usersCubit = UsersCubit(repository: UserRepoImpl(ApiService()));
    _usersCubit.fetchUserProfile(widget.userId); // جلب بيانات البروفايل فوراً
  }

  @override
  void dispose() {
    _usersCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'ملف شخصي', // عنوان صفحة البروفايل
        ),
      ),
      body: BlocProvider<UsersCubit>.value(
        value: _usersCubit,
        child: BlocConsumer<UsersCubit, UsersState>(
          listener: (context, state) {
            if (state is UserProfileError) {
              showCustomAlertDialog(
                context: context,
                title: 'عذراً! 😢',
                content: 'فشل في تحميل الملف الشخصي: ${state.errorMessage}',
              );
            } else if (state is UserDeleteFailed) {
              showCustomAlertDialog(
                context: context,
                title: 'عذراً! 😢',
                content: 'فشل في حذف الملف الشخصي: ${state.errorMessage}',
              );
            }
            if (state is UserDeleted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsersListScreen()),
              );

              showCustomSnackBar(
                context,
                'تم  حذف بنجاح ',
                color: Palette.primarySuccess,
              );
            }
          },
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2.0),
              );
            } else if (state is UserProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // توسيط المحتوى
                  children: [
                    // صورة البروفايل الدائرية
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueGrey.shade100,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.blueGrey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // اسم المستخدم
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // دور المستخدم (مع لون خلفية)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getRoleColor(user.userRole),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        user.userRole.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // تفاصيل المستخدم في بطاقات أنيقة
                    _buildInfoCard('معلومات الاتصال', [
                      _buildProfileInfoRow(
                        Icons.email,
                        'البريد الإلكتروني:',
                        user.email,
                      ),
                      _buildProfileInfoRow(Icons.phone, 'الهاتف:', user.phone),
                    ]),
                    const SizedBox(height: 20),
                    _buildInfoCard('حالة الحساب', [
                      _buildProfileInfoRow(
                        Icons.verified_user,
                        'الحالة:',
                        user.flag == 1 ? 'فعال' : 'غير فعال',
                        color: user.flag == 1
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                      _buildProfileInfoRow(
                        Icons.vpn_key_outlined,
                        'معرف الـ FCM:',
                        user.fcmToken ?? 'غير متوفر',
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _buildInfoCard('تواريخ مهمة', [
                      _buildProfileInfoRow(
                        Icons.calendar_today,
                        'تاريخ الإنشاء:',
                        user.createdAt.toLocal().toString().split(' ')[0],
                      ),
                      _buildProfileInfoRow(
                        Icons.update,
                        'آخر تحديث:',
                        user.updatedAt.toLocal().toString().split(' ')[0],
                      ),
                    ]),
                    const SizedBox(height: 30),
                    ButtonINCard(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              userId: widget.userId,
                              currentUser: widget.userModel,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        'Update Profile',
                        style: Styles.textStyle18.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ButtonINCard(
                      onPressed: () {
                        showCustomAlertDialog(
                          context: context,
                          title: 'انتبه ',
                          content: "هل  انت  متاكد من حذف هذا المستخدم",
                          actions: [
                            ButtonINCard(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Text(
                                'ألغاء',
                                style: Styles.textStyle18.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              label: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            ButtonINCard(
                              onPressed: () {
                                context.read<UsersCubit>().deleteUser(
                                  widget.userId,
                                );
                              },
                              icon: Text('متاكد'),
                              label: Icon(Icons.done),
                            ),
                          ],
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text(
                        'Delete Profile',
                        style: Styles.textStyle18.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserProfileError) {
              return Center(
                child: ErrorWidetView(
                  message: ' ${state.errorMessage}',
                  onPressed: () {
                    _usersCubit.fetchUserProfile(
                      widget.userId,
                    ); // إعادة المحاولة
                  },
                ),
              );
            }
            return const SizedBox.shrink(); // في الحالة الأولية أو غير المتوقعة
          },
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء صف معلومات بداخل البطاقة
  Widget _buildProfileInfoRow(
    IconData icon,
    String title,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? Colors.blueGrey.shade700),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: color ?? Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لإنشاء بطاقة معلومات (يمكن استخدامها لـ 'معلومات الاتصال', 'حالة الحساب', etc.)
  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ...children, // عرض عناصر المعلومات
          ],
        ),
      ),
    );
  }
}
