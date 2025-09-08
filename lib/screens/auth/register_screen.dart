import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/constants/my_app_colors.dart';
import 'package:tcp212/constants/validate.dart';
import 'package:tcp212/screens/auth/sign_in_screen.dart';
import 'package:tcp212/view_models/auth_cubit/auth_cubit.dart';
import 'package:tcp212/view_models/auth_cubit/auth_state.dart';
import 'package:tcp212/widgets/auth_widget/custom_rich_text.dart';
import 'package:tcp212/widgets/auth_widget/divider_row.dart';
import 'package:tcp212/widgets/auth_widget/dropdown_button_form_field.dart';
import 'package:tcp212/widgets/auth_widget/password_text_field.dart';
import 'package:tcp212/widgets/auth_widget/primary_button.dart';
import 'package:tcp212/widgets/auth_widget/primary_textform_field.dart';
import 'package:tcp212/widgets/auth_widget/secondary_button.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  String? userRole;

  bool isValidSyrianPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'^(?:\+963|09)\d{8}$');
    return regex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    var c = context.read<AuthCubit>();
    return Scaffold(
      backgroundColor: MyAppColors.kWhite,
      appBar: AppBar(
        toolbarHeight: 20.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is SignUpSucces) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
              c.email.clear();
              c.password.clear();
            }
            if (state is SignUpError) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                btnOkColor: MyAppColors.kPrimary,
                title: 'Invalid credentials',
                desc: state.error,
                btnCancelOnPress: () {},
                btnOkOnPress: () {},
              ).show();
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Form(
                key: registerKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Create Account',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  color: MyAppColors.kGrayscaleDark100,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'We happy to see you. Sign Up to your account',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: MyAppColors.kGrayscale40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'First Name',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: MyAppColors.kGrayscaleDark100,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        PrimaryTextformField(
                          keyboard: TextInputType.name,
                          save: (value) {
                            c.name.text = value!;
                          },
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name';
                            } else if (value.length < 3) {
                              return 'enter valid name';
                            }
                            return null;
                          },
                          label: "name",
                          suffixIcon: Icon(Icons.abc),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Email',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: MyAppColors.kGrayscaleDark100,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        PrimaryTextformField(
                          keyboard: TextInputType.emailAddress,
                          save: (value) {
                            c.email.text = value!;
                          },
                          validate: (value) {
                            Validate.emailValidate(value);
                            return null;
                          },
                          suffixIcon: Icon(Icons.email_outlined),
                          label: "email",
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Password',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: MyAppColors.kGrayscaleDark100,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        PasswordTextField(
                          keyboard: TextInputType.visiblePassword,
                          save: (value) {
                            c.password.text = value!;
                          },
                          validate: (value) {
                            Validate.passwordValidate(value);
                            return null;
                          },
                          label: "password",
                          Pass_Security: true,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Phone',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: MyAppColors.kGrayscaleDark100,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        PrimaryTextformField(
                          keyboard: TextInputType.phone,
                          save: (value) {
                            c.phone.text = value!;
                          },
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            } else if (!isValidSyrianPhoneNumber(value)) {
                              return 'Invalid Syrian phone number';
                            }
                            return null;
                          },
                          label: "phonenumber",
                          suffixIcon: Icon(Icons.phone),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Role',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: MyAppColors.kGrayscaleDark100,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        RoleDropdownButton(
                          onChanged: (String? newValue) {
                            userRole = newValue;
                          },
                        ),
                        SizedBox(height: 20.h),
                        Center(
                          child: Column(
                            children: [
                              PrimaryButton(
                                elevation: 0,
                                onTap: () {
                                  if (registerKey.currentState!.validate()) {
                                    registerKey.currentState!.save();
                                    if (userRole != null) {
                                      c.register(userRole: userRole!);
                                    } else {
                                      print("Please select a role.");
                                    }
                                  }
                                },
                                bgColor: MyAppColors.kPrimary,
                                borderRadius: 20,
                                height: 46,
                                width: 327,
                                textColor: MyAppColors.kWhite,
                                child: (state is Loading)
                                    ? CircularProgressIndicator(
                                        color: MyAppColors.kWhite,
                                      )
                                    : Text(
                                        'Create Account',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: MyAppColors.kWhite,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                              ),
                              SizedBox(height: 20.h),
                              CustomRichText(
                                title: 'Already have an account? ',
                                subtitle: 'Log In',
                                onTab: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignInScreen(),
                                    ),
                                  );
                                },
                                subtitleTextStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: MyAppColors.kGrayscaleDark100,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Center(
                          child: Column(
                            children: [
                              const DividerRow(title: 'Or Sign Up with'),
                              SizedBox(height: 24.h),
                              SecondaryButton(
                                height: 56,
                                textColor: MyAppColors.kGrayscaleDark100,
                                width: 260,
                                onTap: () {},
                                borderRadius: 24,
                                bgColor: MyAppColors.kBackground.withOpacity(
                                  0.3,
                                ),
                                text: 'Continue with Google',
                                icons: "assets/images/googleSymbol.png",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
