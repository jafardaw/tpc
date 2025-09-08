import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/style.dart';

class ListTileOfCategoryDeatails extends StatelessWidget {
  final String name;
  final String description;
  final String created;
  final String updated;
  const ListTileOfCategoryDeatails({
    super.key,
    required this.name,
    required this.description,
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
                    text: "Name: ",
                    style: AppTextStyles.calibri24BoldPrimary,
                    children: <TextSpan>[
                      TextSpan(
                        text: name,
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                RichText(
                  text: TextSpan(
                    text: "Description: ",
                    style: AppTextStyles.calibri24BoldPrimary,
                    children: <TextSpan>[
                      TextSpan(
                        text: description,
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
