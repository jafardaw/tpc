import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSalesMainWidget extends StatelessWidget {
  final String name;
  final String price;
  final String customer;
  final String? imageUrl;
  final VoidCallback? onTap;
  const ProductSalesMainWidget(
      {super.key,
      required this.name,
      required this.price,
      required this.customer,
      this.imageUrl,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicWidth(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      height: 100.h,
                      imageUrl: imageUrl ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPVCi0HVdcQ4Dn_n-X0xLligF-51PIZrb--w&s',
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.price_change,
                              color: Colors.green,
                              size: 28.sp,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "$price\$",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 28.sp,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              customer,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
