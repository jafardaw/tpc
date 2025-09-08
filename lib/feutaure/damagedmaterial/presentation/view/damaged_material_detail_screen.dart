import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/profit-loss-report/data/model/sub_profit-loss-report_model.dart';

class DamagedMaterialDetailScreen extends StatelessWidget {
  final DamagedMaterialProfitLossReportModel damagedMaterial;

  const DamagedMaterialDetailScreen({super.key, required this.damagedMaterial});

  @override
  Widget build(BuildContext context) {
    // Determine the name of the damaged material based on its type (raw or semi-finished)
    String materialName;
    if (damagedMaterial.materialType == 'raw') {
      materialName =
          damagedMaterial.rawMaterialBatch?.rawMaterial?.name ??
          'Raw Material (Unknown)';
    } else {
      materialName =
          damagedMaterial.productBatch?.product?.name ??
          'Product/Semi-Finished (Unknown)';
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Damaged Material Details',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.broken_image, // Icon for damaged material
                    color: Colors.orange[700],
                    size: 100,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Material Damage Report',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(
                  height: 40,
                  thickness: 1.5,
                  color: Colors.orangeAccent,
                ),
                _buildDetailRow(
                  context,
                  'Report ID:',
                  damagedMaterial.damagedMaterialId.toString(),
                ),
                _buildDetailRow(
                  context,
                  'Material Type:',
                  damagedMaterial.materialType == 'raw'
                      ? 'Raw Material'
                      : 'Product/Semi-Finished',
                ),
                _buildDetailRow(context, 'Damaged Material:', materialName),
                _buildDetailRow(
                  context,
                  'Damaged Quantity:',
                  '${damagedMaterial.quantity} units',
                ),
                _buildDetailRow(
                  context,
                  'Lost Cost:',
                  NumberFormat.currency(
                    locale: 'en',
                    symbol: 'KWD',
                  ).format(damagedMaterial.lostCost),
                  valueColor: Colors.red[700], // Red color for loss
                ),
                _buildDetailRow(
                  context,
                  'Registration Date:',
                  _formatDate(damagedMaterial.createdAt),
                ),
                _buildDetailRow(
                  context,
                  'Last Update:',
                  _formatDate(damagedMaterial.updatedAt),
                ),
                _buildDetailRow(
                  context,
                  'Registered By (ID):',
                  damagedMaterial.userId.toString(),
                ),

                if (damagedMaterial.notes != null &&
                    damagedMaterial.notes!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Detailed Notes:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    damagedMaterial.notes!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],

                // Additional details for raw material batch if available
                if (damagedMaterial.rawMaterialBatch != null) ...[
                  const SizedBox(height: 30),
                  Text(
                    'Raw Material Batch Details:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: Colors.blueGrey,
                  ),
                  _buildDetailRow(
                    context,
                    'Batch ID:',
                    damagedMaterial.rawMaterialBatch!.rawMaterialBatchId
                        .toString(),
                  ),
                  _buildDetailRow(
                    context,
                    'Input Quantity:',
                    '${damagedMaterial.rawMaterialBatch!.quantityIn}',
                  ),
                  _buildDetailRow(
                    context,
                    'Remaining Quantity:',
                    '${damagedMaterial.rawMaterialBatch!.quantityRemaining}',
                  ),
                  _buildDetailRow(
                    context,
                    'Actual Cost:',
                    NumberFormat.currency(
                      locale: 'en',
                      symbol: 'KWD',
                    ).format(damagedMaterial.rawMaterialBatch!.realCost),
                  ),
                  _buildDetailRow(
                    context,
                    'Supplier:',
                    damagedMaterial.rawMaterialBatch!.supplier,
                  ),
                  _buildDetailRow(
                    context,
                    'Payment Method:',
                    damagedMaterial.rawMaterialBatch!.paymentMethod,
                  ),
                  if (damagedMaterial.rawMaterialBatch!.notes != null &&
                      damagedMaterial.rawMaterialBatch!.notes!.isNotEmpty)
                    _buildDetailRow(
                      context,
                      'Batch Notes:',
                      damagedMaterial.rawMaterialBatch!.notes!,
                    ),
                ],

                // Additional details for product batch if available
                if (damagedMaterial.productBatch != null) ...[
                  const SizedBox(height: 30),
                  Text(
                    'Product/Semi-Finished Batch Details:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: Colors.lightGreen,
                  ),
                  _buildDetailRow(
                    context,
                    'Batch ID:',
                    damagedMaterial.productBatch!.productBatchId.toString(),
                  ),
                  _buildDetailRow(
                    context,
                    'Input Quantity:',
                    '${damagedMaterial.productBatch!.quantityIn}',
                  ),
                  _buildDetailRow(
                    context,
                    'Remaining Quantity:',
                    '${damagedMaterial.productBatch!.quantityRemaining}',
                  ),
                  _buildDetailRow(
                    context,
                    'Actual Cost:',
                    NumberFormat.currency(
                      locale: 'en',
                      symbol: 'KWD',
                    ).format(damagedMaterial.productBatch!.realCost),
                  ),
                  _buildDetailRow(
                    context,
                    'Status:',
                    damagedMaterial.productBatch!.status,
                  ),
                  if (damagedMaterial.productBatch!.notes != null &&
                      damagedMaterial.productBatch!.notes!.isNotEmpty)
                    _buildDetailRow(
                      context,
                      'Batch Notes:',
                      damagedMaterial.productBatch!.notes!,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build an information row
  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.clip, // Prevent text overflow
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format date
  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal());
    } catch (e) {
      return dateString;
    }
  }
}
