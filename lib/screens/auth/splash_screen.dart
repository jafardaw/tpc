import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tcp212/constants/style.dart';
import 'package:tcp212/core/util/app_router.dart';
import 'package:tcp212/core/util/assets_image.dart';

class SplashSreen extends StatefulWidget {
  const SplashSreen({super.key});

  @override
  State<SplashSreen> createState() => _SplashSreenState();
}

class _SplashSreenState extends State<SplashSreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      context.go(AppRoutes.onBoarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.assetsImagesLogo2, width: 200.w, height: 200.w)
                .animate()
                .fadeIn(duration: 1200.ms)
                .scale(begin: const Offset(0.5, 0.5), duration: 1200.ms),
            30.verticalSpace,
            Text("  Welcome to T P C", style: AppTextStyles.calibri22Splach)
                .animate(delay: 1000.ms)
                .fadeIn(duration: 1000.ms)
                .slide(begin: const Offset(0, 0.3)),
          ],
        ),
      ),
    );
  }
}
