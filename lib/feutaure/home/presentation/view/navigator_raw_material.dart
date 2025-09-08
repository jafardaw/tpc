import 'package:flutter/material.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/batch_raw_material_view.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/view/widget/build_conroller_widget.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/raw_material_view.dart';

class NavigatorRawMaterial extends StatelessWidget {
  const NavigatorRawMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'RawMaterials',
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
              title: 'RawMaterial',
              icon: Icons.calendar_today,
              color: Colors.blue[700]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RawMaterialsListPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Monthly Reports Card
            buildReportCard(
              context,
              title: 'RawMaterial Batch',
              icon: Icons.calendar_month,
              color: Colors.green[700]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RawMaterialBatchesListScreen(),
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
