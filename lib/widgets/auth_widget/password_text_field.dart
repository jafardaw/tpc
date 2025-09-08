// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/my_app_colors.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.Text_Position,
    this.Pass_Security,
    this.TextController,
    required this.validate,
    required this.save,
    this.keyboard,
    this.initValue,
  });

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? label;
  final TextEditingController? TextController;
  final TextInputType? keyboard;
  final String? Function(String? value) validate;
  final void Function(String? value) save;
  final bool? Pass_Security;
  final TextAlign? Text_Position;
  final String? initValue;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: TextFormField(
        textAlign: widget.Text_Position ?? TextAlign.start,
        obscureText: _obscureText,
        controller: widget.TextController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(18),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: MyAppColors.kPrimary),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          label: widget.label != null
              ? Text(
                  widget.label!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: MediaQuery.of(context).size.width / 30,
                      ),
                )
              : null,
          filled: true,
          fillColor: MyAppColors.kBackground2,
          prefixIcon: widget.prefixIcon,
          suffixIcon: IconButton(
                icon: Icon( 
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: MyAppColors.kPrimary,
                  size: 17.h,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
        ),
        keyboardType: widget.keyboard,
        validator: widget.validate,
        onSaved: widget.save,
        obscuringCharacter: '*',
        textCapitalization: TextCapitalization.none,
        initialValue: widget.initValue,
      ),
    );
  }
}