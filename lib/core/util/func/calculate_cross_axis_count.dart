import 'package:flutter/material.dart';

int calculateCrossAxisCount(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width > 1200) {
    return 4;
  } else if (width > 800) {
    return 3;
  } else if (width > 500) {
    return 2;
  } else {
    return 1;
  }
}
