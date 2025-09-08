import 'package:flutter/material.dart';
import 'package:tcp212/core/util/const.dart';

class ButtonINCard extends StatelessWidget {
  const ButtonINCard({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });
  final void Function() onPressed;
  final Widget icon;
  final Widget label;
  final Color? backgroundColor = Palette.primary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
