import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/my_app_colors.dart';

class RoleDropdownButton extends StatelessWidget {
  const RoleDropdownButton({super.key, this.onChanged});
  final void Function(String?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290.w,
      height: 43.h,
      child: DropdownButtonFormField<String>(
        initialValue: 'accountant',
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: MyAppColors.kPrimary, width: 2),
            borderRadius: BorderRadius.circular(15.r),
          ),
          labelStyle: TextStyle(color: Colors.black, fontSize: 15),
          hintStyle: TextStyle(color: Colors.grey),
          hintText: 'Select Role',
          labelText: 'Role',
          floatingLabelStyle: TextStyle(
            fontSize: 18.sp,
            color: MyAppColors.kPrimary,
          ),
        ),
        items: ['accountant', 'warehouse_keeper']
            .map(
              (role) => DropdownMenuItem(
                value: role,
                child: Text(role, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
