import 'package:flutter/material.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/get_product_setting_cubit.dart';
import 'package:tcp212/feutaure/ProductionSettings/repo/production_settings_repo.dart';

class Palette {
  Palette._();
  static const Color primary = Color(0XFF1460F2);
  static const Color primarySuccess = Colors.green;
  static const Color primaryError = Colors.red;

  static const Color primaryDark = Color(0XFFFFFFFF);
  static const Color primaryLight = Color(0XFFFAFAFA);
  static const Color backgroundColor = Color(0xffF5F2F2);
  static const Color kGrayscale40 = Color(0XFFAEAEB2);
}

class MyAppColors {
  static Color kPrimary = const Color(0XFF1460F2);
  static Color kWhite = const Color(0XFFFFFFFF);
  static Color kBackground = const Color(0XFFFAFAFA);
  static Color kGrayscaleDark100 = const Color(0XFF1C1C1E);
  static Color kLine = const Color(0XFFEBEBEB);
  static Color kBackground2 = const Color(0XFFF6F6F6);
  static Color kOnBoardingColor = const Color(0XFFFEFEFE);
  static Color kGrayscale40 = const Color(0XFFAEAEB2);
}

final apiService = ApiService();
final productionSettingsRepo = ProductionSettingsRepo(apiService);
final productionSettingsCubit = ProductionSettingsCubit(
  repository: productionSettingsRepo,
);

Color getRoleColor(String role) {
  switch (role.toLowerCase()) {
    case 'admin':
      return Colors.red.shade600;
    case 'accountant':
      return Colors.purple.shade600;
    case 'warehouse_keeper':
      return Colors.orange.shade600;
    default:
      return Colors.grey.shade600;
  }
}
