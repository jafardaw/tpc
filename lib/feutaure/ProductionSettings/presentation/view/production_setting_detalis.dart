import 'package:flutter/material.dart';
import 'package:tcp212/core/util/func/float_action_botton.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/entities/production_setting.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/add_production_page.dart';

class ProductionSettingDetailPage extends StatelessWidget {
  final ProductionSetting setting;

  const ProductionSettingDetailPage({super.key, required this.setting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Production Settings Details',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(context),
            const SizedBox(height: 20),

            // Details Section
            _buildDetailCard(
              title: "Basic Information",
              icon: Icons.info_outline,
              children: [
                _buildDetailRow(
                  "Total Production",
                  "${setting.totalProduction}",
                ),
                _buildDetailRow(
                  "Profit Ratio",
                  "${setting.profitRatio * 100}%",
                ),
                _buildDetailRow(
                  "Type",
                  setting.type == 'estimated' ? "Estimated" : "Actual",
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Time Section
            _buildDetailCard(
              title: "Timing",
              icon: Icons.calendar_today,
              children: [
                _buildDetailRow("Month", "${setting.month}"),
                _buildDetailRow("Year", "${setting.year}"),
                _buildDetailRow(
                  "Created At",
                  "${setting.createdAt.toLocal()}".split('.')[0],
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Notes Section
            if (setting.notes.isNotEmpty)
              _buildDetailCard(
                title: "Notes",
                icon: Icons.notes,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      setting.notes,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: buildFloatactionBouttonW(
        context,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductionSettingsScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.settings, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              "Production Settings",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "ID: ${setting.productionSettingsId}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue[800]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
