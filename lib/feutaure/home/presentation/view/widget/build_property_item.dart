import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/my_app_colors.dart';

Widget buildPropertyItem(
  IconData icon,
  String title,
  String value,
  void Function() onTap,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: MyAppColors.kPrimary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: MyAppColors.kPrimary, size: 20.w),
        ),
      ),
      SizedBox(height: 6.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey[600],
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
      SizedBox(height: 2.h),
      Text(
        value,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: MyAppColors.kPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
