import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmmountField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const AmmountField({
    super.key, 
    required this.hint,
    this.controller,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      radius: 10,
      child: TextFormField(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        controller: controller,
        validator: validator,
        onSaved: onSaved,
       
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 3.h),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFF00BAAB))),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Colors.red)),
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 18.sp, color: const Color(0xFF5E5E5E),fontWeight: FontWeight.bold,),
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const PrimaryContainer({
    super.key,
    this.radius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(radius ?? 30),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: color ?? Colors.grey,
          ),
          const BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Colors.white,
          ),
        ],
      ),
      child: child,
    );
  }
}
