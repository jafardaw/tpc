import 'package:flutter/material.dart';
import 'package:tcp212/core/util/const.dart';

FloatingActionButton buildFloatactionBouttonW(
  BuildContext context, {
  required Function() onPressed,
}) {
  return FloatingActionButton(
    onPressed: onPressed,
    backgroundColor: Palette.primary,
    child: const Icon(Icons.add, color: Colors.white),
  );
}
