import 'dart:ui';

import 'package:flutter/material.dart';

class MyAppColors {
  static Color kPrimary = const Color(0XFF1460F2);
  static Color kWhite = const Color(0XFFFFFFFF);
  static Color kBackground = const Color(0XFFFAFAFA);
  static Color kGrayscaleDark100 = const Color(0XFF1C1C1E);
  static Color kLine = const Color(0XFFEBEBEB);
  static Color kBackground2 = const Color(0XFFF6F6F6);
    static Color kOnBoardingColor = const Color(0XFFFEFEFE);
  static Color kGrayscale40 = const Color(0XFFAEAEB2);

   static Color getCategoryColor(String categoryName) {
    String lowerName = categoryName.toLowerCase();

    if (lowerName.contains('food') || lowerName.contains('restaurant') || lowerName.contains('meal')) {
      return Colors.orange;
    } else if (lowerName.contains('transport') || lowerName.contains('car') || lowerName.contains('gas')) {
      return Colors.blue;
    } else if (lowerName.contains('shopping') || lowerName.contains('clothes') || lowerName.contains('store')) {
      return Colors.pink;
    } else if (lowerName.contains('entertainment') || lowerName.contains('movie') || lowerName.contains('game')) {
      return Colors.purple;
    } else if (lowerName.contains('health') || lowerName.contains('medical') || lowerName.contains('doctor')) {
      return Colors.red;
    } else if (lowerName.contains('education') || lowerName.contains('book') || lowerName.contains('study')) {
      return Colors.indigo;
    } else if (lowerName.contains('home') || lowerName.contains('house') || lowerName.contains('rent')) {
      return Colors.brown;
    } else if (lowerName.contains('bills') || lowerName.contains('electricity') || lowerName.contains('water')) {
      return Colors.cyan;
    } else if (lowerName.contains('travel') || lowerName.contains('vacation') || lowerName.contains('trip')) {
      return Colors.teal;
    } else if (lowerName.contains('gym') || lowerName.contains('fitness') || lowerName.contains('sport')) {
      return Colors.green;
    } else if (lowerName.contains('coffee') || lowerName.contains('drink')) {
      return Colors.amber;
    } else if (lowerName.contains('gift') || lowerName.contains('present')) {
      return Colors.deepPurple;
    } else if (lowerName.contains('pet') || lowerName.contains('animal')) {
      return Colors.deepOrange;
    } else if (lowerName.contains('beauty') || lowerName.contains('salon') || lowerName.contains('hair')) {
      return Colors.pinkAccent;
    } else if (lowerName.contains('phone') || lowerName.contains('mobile') || lowerName.contains('communication')) {
      return Colors.lightBlue;
    } else if (lowerName.contains('internet') || lowerName.contains('wifi') || lowerName.contains('online')) {
      return Colors.lightGreen;
    } else {
      return Colors.grey;
    }
  }
}
