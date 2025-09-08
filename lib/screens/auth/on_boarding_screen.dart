import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tcp212/constants/my_app_colors.dart';
import 'package:tcp212/constants/on_boarding.dart';
import 'package:tcp212/core/util/app_router.dart';
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Skip
                  Padding(
                    padding: EdgeInsets.only(left: 14.w, top: 12.h),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          context.goNamed(AppRoutes.register);
                        },
                        child: Text(
                          'skip',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  /// PageView
                  SizedBox(
                    height: 330.h,
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

                  SizedBox(height: 36.h),

                  /// Dots
                  Center(
                    child: DotsIndicator(
                      dotsCount: onBoardinglist.length,
                      position: _currentIndex.toDouble(),
                      decorator: DotsDecorator(
                        color: MyAppColors.kPrimary.withOpacity(0.4),
                        size: Size.square(10.0.sp),
                        activeSize: Size(20.0.sp, 8.0.sp),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        activeColor: MyAppColors.kPrimary,
                      ),
                    ),
                  ),

                  SizedBox(height: 37.h),

                  /// Title + Description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        Text(
                          onBoardinglist[_currentIndex].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          onBoardinglist[_currentIndex].description,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  /// Next / Get Started Button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 25.w, bottom: 30.h),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_currentIndex == onBoardinglist.length - 1) {
                              context.goNamed(AppRoutes.register);
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                              );
                            }
                          });
                        },
                        child: Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            color: MyAppColors.kPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
