import 'package:flutter/material.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/view/widget/build_conroller_widget.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/get_production_setting_by_month_page.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/production_settings_page.dart';

class ProductSettingControllerView extends StatelessWidget {
  const ProductSettingControllerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Product Setting',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Daily Reports Card
            buildReportCard(
              context,
              title: 'Monthly Production Overview',
              icon: Icons.calendar_today,
              color: Colors.blue[700]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductionSettingsOverviewScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Monthly Reports Card
            buildReportCard(
              context,
              title: 'ProductionSettings',
              icon: Icons.calendar_month,
              color: Colors.green[700]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductionSettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
