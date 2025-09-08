import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/style.dart';

class ListTileOfDeatails extends StatelessWidget {
  final String ammount;
  final String type;
  final String notes;
  final String created;
  final String updated;
  const ListTileOfDeatails({
    super.key,
    required this.ammount,
    required this.type,
    required this.notes,
    required this.created,
    required this.updated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Ammount: ",
                    style: AppTextStyles.calibri24BoldPrimary,
                    children: <TextSpan>[
                      TextSpan(
                        text: ammount,
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                RichText(
                  text: TextSpan(
                    text: "type: ",
                    style: AppTextStyles.calibri24BoldPrimary,
                    children: <TextSpan>[
                      TextSpan(
                        text: type,
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                RichText(
                  text: TextSpan(
                    text: "notes: ",
                    style: AppTextStyles.calibri24BoldPrimary,
                    children: <TextSpan>[
                      TextSpan(
                        text: notes,
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                RichText(
                  text: TextSpan(
                    text: "created at: ",
                    style: AppTextStyles.calibri24BoldPrimary,
                    children: <TextSpan>[
                      TextSpan(
                        text: created,
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                RichText(
                  text: TextSpan(
                    text: "updated at: ",
                    style: AppTextStyles.calibri24BoldPrimary,
                    children: <TextSpan>[
                      TextSpan(
                        text: updated,
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
