import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // Calibri font styles
  static TextStyle calibri26NormalWhiteShadow = TextStyle(
    fontSize: 26.0.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    shadows: [
      Shadow(blurRadius: 10.0, color: Colors.blueAccent, offset: Offset(0, 0)),
    ],
  );
   static TextStyle grayscale40 = TextStyle(
    fontSize: 26.0.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    shadows: [
      Shadow(blurRadius: 10.0, color: Colors.blueGrey, offset: Offset(0, 0)),
    ],
  );

  static TextStyle calibri19NormalWhiteShadow = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    shadows: [
      Shadow(blurRadius: 10.0, color: Colors.blueAccent, offset: Offset(0, 0)),
    ],
  );

  static TextStyle calibri14RegularGrey300 = TextStyle(
    fontSize: 14.sp,
    color: Colors.grey[300],
    fontWeight: FontWeight.w400,
  );

  static TextStyle calibri16BoldWhite = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle calibri14BoldBlueAccentUnderline = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: Colors.blueAccent,
    decoration: TextDecoration.underline,
  );
  static TextStyle calibri22Splach = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 63, 66, 154),
    letterSpacing: 2,
  );

  static TextStyle calibri15MediumBlack800 = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle calibri18RegularWhite = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle calibri13ItalicGrey600 = TextStyle(
    fontSize: 13.sp,
    fontStyle: FontStyle.italic,
    color: Colors.grey[600],
  );

  // New Calibri styles
  static TextStyle calibri24BoldPrimary = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  static TextStyle calibri12LightGrey500 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    color: Colors.grey[500],
  );

  static TextStyle calibri20SemiBoldBlack = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle calibri16MediumWhiteWithShadow = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    shadows: [
      Shadow(blurRadius: 4.0, color: Colors.black38, offset: Offset(1, 1)),
    ],
  );

  static TextStyle calibri10RegularGrey400 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: Colors.grey[400],
  );

  // Other font families
  static TextStyle roboto14RegularBlack = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle roboto16MediumPrimary = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
  );

  static TextStyle roboto18BoldWhite = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle openSans12SemiBoldGrey600 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: Colors.grey[600],
  );

  static TextStyle openSans14RegularBlack = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  // Special styles
  static TextStyle errorTextStyle = TextStyle(
    fontSize: 12.sp,
    color: Colors.red[700],
    fontWeight: FontWeight.w500,
  );

  static TextStyle successTextStyle = TextStyle(
    fontSize: 12.sp,
    color: Colors.green[700],
    fontWeight: FontWeight.w500,
  );

  static TextStyle linkTextStyle = TextStyle(
    fontSize: 14.sp,
    color: Colors.blue[700],
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );

  static TextStyle buttonTextStyle = TextStyle(
    fontSize: 16.sp,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle appBarTitleStyle = TextStyle(
    fontSize: 20.sp,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static TextStyle inputLabelStyle = TextStyle(
    fontSize: 14.sp,
    color: Colors.grey[800],
    fontWeight: FontWeight.w500,
  );

  static TextStyle hintTextStyle = TextStyle(
    fontSize: 14.sp,
    color: Colors.grey[500],
    fontWeight: FontWeight.normal,
  );

  static TextStyle chipTextStyle = TextStyle(
    fontSize: 12.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tabBarTextStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );
}
