import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcp212/constants/my_app_colors.dart';
import 'package:tcp212/feutaure/home/presentation/view/home_view.dart';
import 'package:tcp212/screens/auth/register_screen.dart';
import 'package:tcp212/view_models/auth_cubit/auth_cubit.dart';
import 'package:tcp212/view_models/auth_cubit/auth_state.dart';
import 'package:tcp212/widgets/auth_widget/custom_rich_text.dart';
import 'package:tcp212/widgets/auth_widget/divider_row.dart';
import 'package:tcp212/widgets/auth_widget/password_text_field.dart';
import 'package:tcp212/widgets/auth_widget/primary_button.dart';
import 'package:tcp212/widgets/auth_widget/primary_text_button.dart';
import 'package:tcp212/widgets/auth_widget/primary_textform_field.dart';
import 'package:tcp212/widgets/auth_widget/secondary_button.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  GlobalKey<FormState> logInKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.kWhite,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSucces) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          }
          if (state is LoginError) {
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
            var c = context.read<AuthCubit>();

            return Form(
              key: logInKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: 300.w,
                    child: Column(
                      children: [
                        Text(
                          'Hi, Welcome Back! 👋',
                          textAlign: TextAlign.center,
                          style:
                              GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ).copyWith(
                                color: MyAppColors.kGrayscaleDark100,
                                fontSize: 20.sp,
                              ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'We happy to see you. Sign In to your account',
                          textAlign: TextAlign.center,
                          style:
                              GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MyAppColors.kWhite,
                              ).copyWith(
                                color: MyAppColors.kGrayscale40,
                                fontSize: 13.sp,
                              ),
                        ),
                        const SizedBox(height: 36),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style:
                                  GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: MyAppColors.kWhite,
                                  ).copyWith(
                                    color: MyAppColors.kGrayscaleDark100,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                            ),
                            SizedBox(height: 7.h),
                            PrimaryTextformField(
                              save: (email) {
                                c.email.text = email!;
                              },
                              validate: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "email required";
                                }
                                int index = 0;
                                for (int i = 0; i < value.length; i++) {
                                  if (value[i] == '@') {
                                    index = i;
                                    break;
                                  }
                                }
                                String email = value.substring(0, index);
                                if (int.tryParse(email) != null ||
                                    double.tryParse(email) != null ||
                                    email.length < 5) {
                                  return "invalid email";
                                }
                                return null;
                              },
                              TextController: c.email,
                              label: "email",
                              suffixIcon: Icon(Icons.email_outlined),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style:
                                  GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: MyAppColors.kWhite,
                                  ).copyWith(
                                    color: MyAppColors.kGrayscaleDark100,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                            ),
                            SizedBox(height: 7.h),
                            PasswordTextField(
                              save: (pass) {
                                c.password.text = pass!;
                              },
                              validate: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "password missing";
                                }
                                if (value.trim().length < 8) {
                                  return "password too short";
                                }
                                return null;
                              },
                              label: "password",
                              TextController: c.password,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PrimaryTextButton(
                              onPressed: () {},
                              title: 'Forgot Password?',
                              textStyle: const TextStyle(),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        Column(
                          children: [
                            PrimaryButton(
                              elevation: 0,
                              onTap: () {
                                if (logInKey.currentState!.validate()) {
                                  logInKey.currentState!.save();
                                  c.logIn();
                                }
                              },
                              bgColor: MyAppColors.kPrimary,
                              borderRadius: 20.r,
                              height: 38.h,
                              width: 280.w,
                              textColor: MyAppColors.kWhite,
                              fontSize: 14.sp,
                              child: (state is Loading)
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'LogIn',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: MyAppColors.kWhite,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                            ),
                            SizedBox(height: 22.h),
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: CustomRichText(
                                title: "Don't have an account?",
                                subtitle: " Create here",
                                onTab: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ),
                                  );
                                },
                                subtitleTextStyle:
                                    GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: MyAppColors.kWhite,
                                    ).copyWith(
                                      color: MyAppColors.kPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45),
                          child: Column(
                            children: [
                              const DividerRow(title: 'Or Sign In with'),
                              SizedBox(height: 20.h),
                              SecondaryButton(
                                height: 56,
                                textColor: MyAppColors.kGrayscaleDark100,
                                width: 280.w,
                                onTap: () {},
                                borderRadius: 24.r,
                                bgColor: MyAppColors.kBackground.withOpacity(
                                  0.3,
                                ),
                                text: 'Continue with Google',
                                icons: "assets/images/googleSymbol.png",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
