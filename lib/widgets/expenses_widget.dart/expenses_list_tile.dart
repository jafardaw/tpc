import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/core/util/assets_image.dart';

class ExpensesListTile extends StatelessWidget {
  final double ammount;
  final String type;
  final void Function()? onPressed;
  const ExpensesListTile({
    super.key,
    required this.ammount,
    required this.type,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.r,
              child: Image.asset(Assets.expenses, height: 40.h),
            ),
            title: Text(
              '\$$ammount',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              type,
              style: TextStyle(fontSize: 15.sp, color: Colors.grey[600]!),
            ),
            trailing: IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.arrow_forward_ios, size: 17.sp),
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
