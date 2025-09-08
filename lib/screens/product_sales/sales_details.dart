import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tcp212/constants/style.dart';
import 'package:tcp212/core/util/app_router.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/view_models/product_sales_cubit/product_sales_cubit.dart';
import 'package:tcp212/view_models/product_sales_cubit/product_sales_state.dart';
import 'package:tcp212/widgets/product_sales_widget/delete_button_widget.dart';
import 'package:tcp212/widgets/product_sales_widget/divider_widget.dart';

class SalesDetails extends StatelessWidget {
  const SalesDetails({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductSalesCubit()..fetchProductSales(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading:
                true, // Set to false if this is a root page
            title: 'Product Sales details',
          ),
        ),
        body: BlocBuilder<ProductSalesCubit, ProductSalesState>(
          builder: (context, state) {
            if (state is ProductSalesLoaded) {
              final productSales = state.productSales;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 10.w),
                        Text(
                          "Sales information",
                          style: AppTextStyles.calibri20SemiBoldBlack,
                        ),
                        Expanded(
                          child: DividerWidget(
                            title: "Date ",
                            subTitle: productSales.first.createdAt.toString(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DividerWidget(
                          title: "Sale id ",
                          subTitle:
                              "#${productSales.first.productSaleId.toString()}",
                        ),
                        DividerWidget(
                          title: "Product ",
                          subTitle: productSales.first.product.name,
                        ),
                        DividerWidget(
                          title: "Product batch ",
                          subTitle:
                              "Batch ${productSales.first.productBatchId.toString()}",
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DividerWidget(
                          title: "Quantity sold",
                          subTitle:
                              "${productSales.first.productBatch.quantityIn.toString()} Units",
                        ),
                        DividerWidget(
                          title: "Unit price ",
                          subTitle: productSales.first.unitPrice.toString(),
                        ),
                        DividerWidget(
                          title: "Customer ",
                          subTitle: productSales.first.customer,
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Text(
                        "Financials",
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DividerWidget(
                          title: "Revenue ",
                          subTitle: "${productSales.first.revenue}\$",
                        ),
                        DividerWidget(
                          title: "Net profit/Loss ",
                          subTitle: "${productSales.first.netProfit}\$",
                        ),
                      ],
                    ),
                    SizedBox(height: 60.h),
                    Center(
                      child: DeleteButtonWidget(
                        onPressed: () {
                          context.read<ProductSalesCubit>().deleteSale(
                            productSales.first.productSaleId,
                          );
                          context.pushNamed(AppRoutes.productSales);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProductSalesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductSalesError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text("No data"));
            }
          },
        ),
      ),
    );
  }
}
