import 'package:flutter/material.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/Product/presentation/view/all_product_view.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/view/widget/build_conroller_widget.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/all_product_batch_view.dart';
import 'package:tcp212/feutaure/productmaterial/presentation/view/all_product_material_view.dart';

class NavigatorProduct extends StatelessWidget {
  const NavigatorProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(automaticallyImplyLeading: true, title: 'Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Daily Reports Card
            buildReportCard(
              context,
              title: 'All Products',
              icon: Icons.calendar_today,
              color: Colors.blue[700]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListView()),
                );
              },
            ),
            const SizedBox(height: 20),

            buildReportCard(
              context,
              title: ' ProductMaterials',
              icon: Icons.calendar_today,
              color: const Color.fromARGB(255, 192, 210, 25),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductMaterialsListView(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Monthly Reports Card
            buildReportCard(
              context,
              title: 'Product Batch',
              icon: Icons.calendar_month,
              color: Colors.green[700]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductBatchListView(),
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
