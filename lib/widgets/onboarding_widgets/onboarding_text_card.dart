import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcp212/constants/my_app_colors.dart';
import 'package:tcp212/constants/on_boarding.dart';

class OnboardingTextCard extends StatelessWidget {
  final OnBoarding onBoardingModel;
  const OnboardingTextCard({required this.onBoardingModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        children: [
          Text(
            onBoardingModel.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MyAppColors.kGrayscaleDark100,
            ).copyWith(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Text(
            onBoardingModel.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: MyAppColors.kWhite,
            ).copyWith(color: MyAppColors.kGrayscale40, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
