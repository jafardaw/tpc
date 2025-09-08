import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/my_app_colors.dart';
import 'package:tcp212/constants/on_boarding.dart';
import 'package:tcp212/screens/auth/register_screen.dart';
import 'package:tcp212/widgets/auth_widget/primary_button.dart';
import 'package:tcp212/widgets/onboarding_widgets/on_boarding_card.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.kOnBoardingColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // تحديد الارتفاعات بناءً على حجم الشاشة
            final bool isSmallScreen = constraints.maxHeight < 700;
            final double topCircleSize = isSmallScreen ? 8.h : 10.h;
            final double topCircleMargin = isSmallScreen ? 15.w : 25.w;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isSmallScreen ? 2.h : 5.h),
                Container(
                  height: topCircleSize,
                  width: topCircleSize,
                  margin: EdgeInsets.all(topCircleMargin),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyAppColors.kPrimary,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8.h : 14.h),

                /// قسم العروض الرئيسية
                Expanded(
                  flex: isSmallScreen ? 4 : 5,
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: onBoardinglist.length,
                    physics: const BouncingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnBoardingCard(
                        onBoardingModel: onBoardinglist[index],
                      );
                    },
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20.h : 36.h),

                /// مؤشر النقاط
                Center(
                  child: DotsIndicator(
                    dotsCount: onBoardinglist.length,
                    position: _currentIndex.toDouble(),
                    decorator: DotsDecorator(
                      color: MyAppColors.kPrimary.withOpacity(0.4),
                      size: Size.square(8.0.sp),
                      activeSize: Size(20.0.sp, 8.0.sp),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      activeColor: MyAppColors.kPrimary,
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20.h : 37.h),

                Expanded(
                  flex: isSmallScreen ? 3 : 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          onBoardinglist[_currentIndex].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16.sp : 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8.h : 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          onBoardinglist[_currentIndex].description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12.sp : 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 15.h : 25.h),

                /// زر الانتقال بين الصفحات
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 25.w,
                      right: 23.w,
                      bottom: isSmallScreen ? 15.h : 30.h,
                    ),
                    child: PrimaryButton(
                      elevation: 0,
                      onTap: () {
                        setState(() {
                          if (_currentIndex == onBoardinglist.length - 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                          }
                        });
                      },
                      bgColor: MyAppColors.kPrimary,
                      borderRadius: 20.r,
                      height: isSmallScreen ? 36.h : 40.h,
                      width: 280.w,
                      textColor: MyAppColors.kWhite,
                      child: Text(
                        _currentIndex == onBoardinglist.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14.sp : 16.sp,
                          fontWeight: FontWeight.w500,
                          color: MyAppColors.kWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
