import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/alert_dilog.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/custom_button.dart';
import 'package:tcp212/core/widget/custom_field.dart';
import 'package:tcp212/feutaure/allUsers/data/model/user_model.dart';
import 'package:tcp212/feutaure/allUsers/presentation/manger/cubit/user_cubit.dart';
import 'package:tcp212/feutaure/allUsers/presentation/manger/cubit/user_state.dart';
import 'package:tcp212/feutaure/allUsers/repo/user_repo.dart';

class EditProfileScreen extends StatefulWidget {
  final int userId;
  final UserModel currentUser;

  const EditProfileScreen({
    super.key,
    required this.userId,
    required this.currentUser,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  late UsersCubit _usersCubit;

  @override
  void initState() {
    super.initState();
    _usersCubit = UsersCubit(repository: UserRepoImpl(ApiService()));

    _nameController = TextEditingController(text: widget.currentUser.name);
    _emailController = TextEditingController(text: widget.currentUser.email);
    _phoneController = TextEditingController(text: widget.currentUser.phone);
    _passwordController = TextEditingController(); // تهيئة متحكم كلمة المرور
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
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
          title: 'Update : ${widget.currentUser.name}',
        ),
      ),
      body: BlocProvider<UsersCubit>.value(
        value: _usersCubit,
        child: BlocConsumer<UsersCubit, UsersState>(
          listener: (context, state) {
            if (state is UserUpdated) {
              showCustomSnackBar(
                context,
                state.message,
                color: Palette.primarySuccess,
              );

              Navigator.pop(context, true);
            } else if (state is UserUpdateFailed) {
              showCustomAlertDialog(
                context: context,
                title: 'عذراً! 😢',
                content: 'فشل تحديث المستخدم: ${state.errorMessage}',
              );
            }
          },
          builder: (context, state) {
            if (state is UserUpdating && state.userId == widget.userId) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2.0),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تفاصيل المستخدم:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      controller: _nameController,
                      label: const Text('الاسم'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _emailController,
                      label: const Text('البريد الإلكتروني'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'الرجاء إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _phoneController,
                      label: const Text('رقم الهاتف'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // حقل كلمة المرور (اختياري)
                    CustomTextField(
                      controller: _passwordController,
                      label: const Text('كلمة المرور (اختياري)'),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true, // لإخفاء النص
                      validator: (value) {
                        // كلمة المرور اختيارية، لذا لا تطلبها إلا إذا أدخلها المستخدم
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length < 6) {
                          return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                        }
                        return null; // لا يوجد خطأ إذا كانت فارغة
                      },
                    ),

                    const SizedBox(height: 30),
                    CustomButton(
                      text: "حفظ التغييرات",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _usersCubit.updateProfile(
                            userId: widget.userId,
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            password: _passwordController.text.isNotEmpty
                                ? _passwordController.text
                                : null,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
