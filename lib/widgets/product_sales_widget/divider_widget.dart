import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/style.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, required this.title, required this.subTitle});
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Divider(
            color: Colors.grey[400],
            thickness: 2,
            endIndent: 30.w,
            height: 20,
            indent: 30.w,
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10.h),
          Text(subTitle, style: AppTextStyles.calibri15MediumBlack800),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
