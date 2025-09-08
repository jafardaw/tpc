import 'package:flutter/material.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/view/monthly_profit_screen.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/view/product_summary_report_screen.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/view/widget/build_conroller_widget.dart';

class ReportsControlScreen extends StatelessWidget {
  const ReportsControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'ReportsControlScreen',
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
              title: 'MonthlyProfit',
              icon: Icons.calendar_today,
              color: Colors.blue[700]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MonthlyProfitScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Monthly Reports Card
            buildReportCard(
              context,
              title: 'ProductSummaryReports',
              icon: Icons.calendar_month,
              color: Colors.green[700]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductSummaryReportScreen(),
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
