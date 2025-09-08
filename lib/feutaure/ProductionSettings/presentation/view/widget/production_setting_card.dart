import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/entities/production_setting.dart';

class ProductionSettingCard extends StatelessWidget {
  final ProductionSetting setting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showActions;

  const ProductionSettingCard({
    super.key,
    required this.setting,
    required this.onEdit,
    required this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${setting.type == 'real' ? 'Real' : 'Estimated'} Production for ${DateFormat.yMMM().format(DateTime(setting.year, setting.month))}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: setting.type == 'real'
                          ? Colors.green[700]
                          : Colors.blue[700],
                    ),
                  ),
                ),
                if (showActions) _buildActionButtons(context, onDelete),
              ],
            ),
            const Divider(height: 16, thickness: 1),
            _buildDetailRow(
              'Total Production:',
              '\$${setting.totalProduction.toStringAsFixed(2)}',
            ),
            _buildDetailRow(
              'Profit Ratio:',
              '${(setting.profitRatio * 100).toStringAsFixed(2)}%',
            ),
            if (setting.notes.isNotEmpty)
              _buildDetailRow('Notes:', setting.notes, isNotes: true),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Updated: ${DateFormat('MMM d, yyyy HH:mm').format(setting.updatedAt)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, void Function()? onPressed) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
          onPressed: onEdit,
          tooltip: 'Edit',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onPressed,
          tooltip: 'Delete',
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isNotes = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: isNotes
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: isNotes ? 14 : 16)),
          ),
        ],
      ),
    );
  }
}
