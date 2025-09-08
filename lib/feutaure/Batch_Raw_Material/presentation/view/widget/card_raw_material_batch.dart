import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/view/create_damaged_material_screen.dart';

class RawMaterialBatchCard extends StatelessWidget {
  final int batchId;
  final String rawMaterialName;
  final double quantityIn;
  final double quantityOut;
  final double quantityRemaining;
  final double realCost;
  final String supplier;
  final String paymentMethod;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String rawMaterialDescription;
  final double rawMaterialPrice;
  final String rawMaterialStatus;
  final int minimumStockAlert;
  final bool isLowStock;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final bool isDeleting;

  const RawMaterialBatchCard({
    super.key,
    required this.batchId,
    required this.rawMaterialName,
    required this.quantityIn,
    required this.quantityOut,
    required this.quantityRemaining,
    required this.realCost,
    required this.supplier,
    required this.paymentMethod,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.rawMaterialDescription,
    required this.rawMaterialPrice,
    required this.rawMaterialStatus,
    required this.minimumStockAlert,
    required this.isLowStock,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.isDeleting,
  });

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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Raw Material Name and Stock Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$rawMaterialName (Batch #$batchId)',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 12),
                // Edit Button
                IconButton(
                  icon: Icon(Icons.edit, size: 24, color: Colors.green[600]),
                  onPressed: onEditPressed,
                  tooltip: 'Edit Batch',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                // Delete Button
                IconButton(
                  icon: isDeleting
                      ? const CircularProgressIndicator(strokeWidth: 2.0)
                      : Icon(Icons.delete, size: 24, color: Colors.red[600]),
                  onPressed: isDeleting ? null : onDeletePressed,
                  tooltip: 'Delete Batch',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                // Stock Status Tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isLowStock
                        ? Colors.red.shade600
                        : Colors.green.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isLowStock ? 'Low Stock' : 'In Stock',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(height: 1, thickness: 0.8, color: Colors.indigo),
            const SizedBox(height: 15),
            // Essential Batch Details
            _buildInfoRow(
              'Quantity In',
              '$quantityIn',
              icon: Icons.add_circle_outline,
              iconColor: Colors.blueAccent[700],
            ),
            _buildInfoRow(
              'Quantity Remaining',
              '$quantityRemaining',
              icon: Icons.layers,
              iconColor: isLowStock ? Colors.red : Colors.orange[700],
            ),
            _buildInfoRow(
              'Actual Cost',
              '$realCost SAR',
              icon: Icons.monetization_on,
              iconColor: Colors.purple[700],
            ),
            _buildInfoRow(
              'Supplier',
              supplier,
              icon: Icons.people_alt,
              iconColor: Colors.brown[600],
            ),
            _buildInfoRow(
              'Payment Method',
              paymentMethod,
              icon: Icons.credit_card,
              iconColor: Colors.teal[600],
            ),
            _buildInfoRow(
              'Notes',
              notes.isNotEmpty ? notes : 'No notes available',
              icon: Icons.notes,
              iconColor: Colors.grey[600],
            ),
            const SizedBox(height: 15),
            const Divider(height: 1, thickness: 0.8, color: Colors.grey),
            const SizedBox(height: 15),
            // Creation and Update Dates
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Added: ${DateFormat('yyyy-MM-dd HH:mm').format(createdAt.toLocal())}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date Updated: ${DateFormat('yyyy-MM-dd HH:mm').format(updatedAt.toLocal())}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Divider(height: 1, thickness: 0.8, color: Colors.blueGrey),
            const SizedBox(height: 15),
            // Related Raw Material Details
            Text(
              'Raw Material Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              'Description',
              rawMaterialDescription.isNotEmpty
                  ? rawMaterialDescription
                  : 'No description available',
              icon: Icons.description,
            ),
            _buildInfoRow(
              'Price',
              '$rawMaterialPrice SAR',
              icon: Icons.price_change,
            ),
            _buildInfoRow(
              'Status',
              rawMaterialStatus,
              icon: Icons.info_outline,
            ),
            _buildInfoRow(
              'Minimum Alert Threshold',
              '$minimumStockAlert',
              icon: Icons.notification_important,
              iconColor: Colors.deepOrange,
            ),

            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: IconButton(
                tooltip: 'create damage',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateDamagedMaterialScreen(
                        rawMaterialBatchIdOrProductBatchId: batchId,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.add_box_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
