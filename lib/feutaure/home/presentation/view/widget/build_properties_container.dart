import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/core/util/styles.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/view/ReportsControlScreen.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/product_setting_controller_view.dart';
import 'package:tcp212/feutaure/allUsers/presentation/user_view.dart';
import 'package:tcp212/feutaure/conversions/presentation/view/conversions_list_screen.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/view/damaged_materials_screen.dart';
import 'package:tcp212/feutaure/home/presentation/view/widget/build_property_item.dart';
import 'package:tcp212/feutaure/notification/presentation/view/notifications_page.dart';
import 'package:tcp212/feutaure/profit-loss-report/presentation/view/profit_loss_view.dart';
import 'package:tcp212/feutaure/simi_products/presentation/view/semi_finished_products_page.dart';
import 'package:tcp212/screens/expences/expense_categories_screen.dart';
import 'package:tcp212/screens/expences/expenses_screen.dart';
import 'package:tcp212/screens/product_sales/product_sales_screen.dart';

Widget buildPropertiesContainer(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Text('What You Want?🤔', style: Styles.textStyle24),
      ),
      SizedBox(height: 16.h),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4, // 4 items per row
        childAspectRatio: 0.95, // Adjust ratio to fit content
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          buildPropertyItem(Icons.swap_horiz, 'Conversions', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConversionsListScreen()),
            );
          }),
          buildPropertyItem(Icons.people, 'All Users', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UsersListScreen()),
            );
          }),
          buildPropertyItem(
            Icons.settings,
            'Production Settings',
            '2023-10',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductSettingControllerView(),
                ),
              );
            },
          ),
          buildPropertyItem(Icons.attach_money, 'Profit Loss', 'Reports', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfitLossReportScreen()),
            );
          }),
          buildPropertyItem(Icons.bar_chart, 'Product Sale', 'Reports', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportsControlScreen()),
            );
          }),
          buildPropertyItem(Icons.warning, 'Damaged Materials', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DamagedMaterialsScreen()),
            );
          }),
          buildPropertyItem(Icons.trending_up, 'Simi', 'Products', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SemiFinishedProductsPage(),
              ),
            );
          }),
          buildPropertyItem(
            Icons.notifications_active_outlined,
            'Notification',
            'TPC',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          buildPropertyItem(Icons.attach_money_rounded, 'Expenses', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpenseScreen()),
            );
          }),
          buildPropertyItem(
            Icons.money_rounded,
            'Expenses Category',
            'TPC',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseCategoriesScreen(),
                ),
              );
            },
          ),
          buildPropertyItem(Icons.sailing, 'Product Sales', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductSalesScreen()),
            );
          }),
        ],
      ),
    ],
  );
}
