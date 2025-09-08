import 'package:flutter/material.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/entities/production_setting.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/widget/buildInfo_row.dart';

class ProductionSettingsByMonthCard extends StatelessWidget {
  const ProductionSettingsByMonthCard({super.key, required this.setting});

  final ProductionSetting setting;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Type: ${setting.type.toUpperCase()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: setting.type == 'estimated'
                        ? Colors.blue.shade700
                        : Colors.green.shade700,
                  ),
                ),
                Text(
                  'ID: ${setting.productionSettingsId}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 15, thickness: 1),
            buildInfoRow(
              Icons.production_quantity_limits,
              'Total Production',
              setting.totalProduction.toStringAsFixed(2),
            ),
            buildInfoRow(
              Icons.percent,
              'Profit Ratio',
              '${(setting.profitRatio * 100).toStringAsFixed(2)}%',
            ),
            buildInfoRow(
              Icons.date_range,
              'Period',
              '${setting.month}/${setting.year}',
            ),
            if (setting.notes.isNotEmpty)
              buildInfoRow(
                Icons.notes,
                'Notes',
                setting.notes, // Use notes! as it's checked for null
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Created: ${setting.createdAt.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Text(
                  'Updated: ${setting.updatedAt.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
