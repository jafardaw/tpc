import 'package:flutter/material.dart';

class WillPopScopeAlertDialog extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? content;
  final Function? onConfirmedPop; // دالة تُنفذ عند تأكيد المستخدم للخروج

  const WillPopScopeAlertDialog({
    super.key,
    required this.child,
    this.title,
    this.content,
    this.onConfirmedPop,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // نمنع الخروج التلقائي
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        // onConfirmedPop!();
        if (didPop) {
          return; // لا تفعل شيئًا إذا تم الخروج بالفعل (نادر مع canPop: false)
        }

        final bool shouldPop =
            await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(title ?? 'تأكيد الخروج'), // عنوان افتراضي
                  content: Text(
                    content ??
                        'هل أنت متأكد أنك تريد مغادرة هذه الصفحة؟ قد تفقد التغييرات غير المحفوظة.',
                  ), // محتوى افتراضي
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // لا تسمح بالخروج
                      },
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // اسمح بالخروج
                      },
                      child: const Text('مغادرة'),
                    ),
                  ],
                );
              },
            ) ??
            false; // القيمة الافتراضية إذا تم رفض مربع الحوار

        if (shouldPop) {
          // إذا اختار المستخدم "مغادرة"
          // قم بتنفيذ الدالة التي تم تمريرها (إذا وجدت)
          onConfirmedPop!();

          // اسمح بالخروج الفعلي من الصفحة
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: child, // هذا هو الـ Widget الذي سيتم لفه بـ PopScope
    );
  }
}
