import 'package:flutter/material.dart';
import 'package:tcp212/core/util/const.dart';

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  List<Widget>? actions,
  bool isRTL = false, // Default to RTL for Arabic
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Directionality(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.blue, width: 2),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 28,
                color: Colors.orange,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Palette.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
            textDirection: TextDirection.ltr, // Content in English
          ),
          actions:
              actions ??
              [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.all(10),
        ),
      );
    },
  );
}
