import 'package:flutter/material.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onTap, required this.text});

  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Palette.primary,
      highlightColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < 600 ? 20 : 50,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Palette.primary, Palette.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              // BoxShadow(
              //   // ignore: deprecated_member_use
              //   color: Colors.blueAccent.withOpacity(0.2),
              //   spreadRadius: 2,
              //   blurRadius: 8,
              //   offset: const Offset(0, 4),
              // ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          width: double.infinity,
          height: MediaQuery.of(context).size.width < 600 ? 50 : 55,
          child: Center(
            child: Text(
              text,
              style: Styles.textStyle18Bold.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
