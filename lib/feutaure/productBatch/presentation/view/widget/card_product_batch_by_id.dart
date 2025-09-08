import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/view/create_damaged_material_screen.dart';
import 'package:tcp212/feutaure/productBatch/data/product_batch_by_id_model.dart';

class ProductCardByid extends StatelessWidget {
  final ProductBatchByid batch;
  final String name;

  const ProductCardByid({super.key, required this.batch, required this.name});

  Widget _buildInfoRow(
    String label,
    String value, {
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, size: 18, color: iconColor ?? Colors.grey[600]),
          if (icon != null) const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedCreatedAt = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(batch.createdAt.toLocal());
    final formattedUpdatedAt = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(batch.updatedAt.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Batch: $name',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateDamagedMaterialScreen(
                          productBathcid: batch.productBatchId,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.add_box_outlined),
                ),
              ],
            ),
            _buildInfoRow(
              'Batch ID',
              '${batch.productBatchId}',
              icon: Icons.batch_prediction,
            ),
            _buildInfoRow(
              'Status',
              batch.status.capitalizeFirstofEach(),
              icon: Icons.check_circle,
              iconColor: batch.status == 'ready' ? Colors.green : Colors.orange,
            ),
            _buildInfoRow(
              'Quantity In',
              '${batch.quantityIn}',
              icon: Icons.add_shopping_cart,
              iconColor: Colors.blue,
            ),
            _buildInfoRow(
              'Quantity Out',
              '${batch.quantityOut}',
              icon: Icons.remove_shopping_cart,
              iconColor: Colors.red,
            ),
            _buildInfoRow(
              'Remaining',
              '${batch.quantityRemaining}',
              icon: Icons.inventory,
              iconColor: Colors.teal,
            ),
            _buildInfoRow(
              'Real Cost',
              '${batch.realCost} SAR',
              icon: Icons.monetization_on,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 15),
            const Divider(height: 1, thickness: 0.8, color: Colors.grey),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created: $formattedCreatedAt',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Updated: $formattedUpdatedAt',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalizeFirstofEach() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}
