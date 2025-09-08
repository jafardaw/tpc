import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends StatelessWidget {
  final String hint;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  const SearchBarWidget({
    super.key,
    required this.hint,
    this.onChanged,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
                      height: 80,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            offset: const Offset(12, 26),
                            blurRadius: 50,
                            spreadRadius: 0,
                            color: Colors.grey.withOpacity(.1)),
                      ]),
                      child: Padding(
                        padding:  EdgeInsets.all(8.0.h),
                        child: TextFormField(
                          validator: validator,
                          controller: controller,
                          onChanged: onChanged,
                          decoration: InputDecoration(
                           
                            filled: true,
                            fillColor: Colors.white,
                            hintText: hint,
                            hintStyle: const TextStyle(color: Colors.grey),
                            contentPadding:  EdgeInsets.symmetric(
                                vertical: 10.0.h, horizontal: 20.0.w),
                            border:  OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0.r)),
                            ),
                            enabledBorder:  OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black26, width: 1.0.sp),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0.r)),
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black26, width: 2.0.sp),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0.r)),
                            ),
                          ),
                        ),
                      ),
                    );
  }
}