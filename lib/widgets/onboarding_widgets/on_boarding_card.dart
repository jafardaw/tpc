import 'package:flutter/material.dart';
import 'package:tcp212/constants/on_boarding.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class OnBoardingCard extends StatefulWidget {
  OnBoarding onBoardingModel;
  OnBoardingCard({super.key, required this.onBoardingModel});

  @override
  State<OnBoardingCard> createState() => _OnBoardingCardState();
}

class _OnBoardingCardState extends State<OnBoardingCard> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(widget.onBoardingModel.image);
  }
}
