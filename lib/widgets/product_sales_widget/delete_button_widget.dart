import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/style.dart';

class DeleteButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  const DeleteButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: onPressed,
      color: Color(0xffFF6B8B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
      height: 50.h,
      minWidth: 200.w,
      child: Text("Delete", style: AppTextStyles.calibri20SemiBoldBlack),
    );
  }
}
