import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcp212/constants/my_app_colors.dart';

class DividerRow extends StatelessWidget {
  final String title;
  const DividerRow({required this.title, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: Divider(color: MyAppColors.kLine)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            title,
            style:
                GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: MyAppColors.kWhite,
                ).copyWith(
                  color: MyAppColors.kGrayscale40,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
          ),
        ),
        Expanded(flex: 2, child: Divider(color: MyAppColors.kLine)),
      ],
    );
  }
}
