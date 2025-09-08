import 'package:flutter/material.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/conversions/data/model/conversions_model.dart';
import 'package:tcp212/feutaure/conversions/presentation/view/product_batch_conversions_screen.dart';

class ConversionDetailsScreen extends StatelessWidget {
  final ConversionModel conversion;

  const ConversionDetailsScreen({super.key, required this.conversion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Conversion #${conversion.conversionId}',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductBatchConversionsScreen(
                      productBatchId:
                          conversion.outputProductBatch!.productBatchId,
                    ),
                  ),
                );
              },
              child: _buildHeaderCard(context),
            ),
            const SizedBox(height: 24),

            _buildDetailCard(
              title: "Conversion Details",
              icon: Icons.info_outline,
              children: [
                _buildDetailRow(
                  "Quantity Used",
                  "${conversion.quantityUsed.toStringAsFixed(2)} units",
                ),
                _buildDetailRow(
                  "Total Cost",
                  "\$${conversion.cost.toStringAsFixed(2)}",
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Output Product Batch Details
            if (conversion.outputProductBatch != null)
              _buildDetailCard(
                title: "Output Product",
                icon: Icons.output,
                children: [
                  _buildDetailRow(
                    "Product Name",
                    conversion.outputProductBatch!.product?.name ?? "N/A",
                  ),
                  _buildDetailRow(
                    "Produced Quantity",
                    "${conversion.outputProductBatch!.quantityIn.toStringAsFixed(2)} units",
                  ),
                  _buildDetailRow(
                    "Remaining Quantity",
                    "${conversion.outputProductBatch!.quantityRemaining.toStringAsFixed(2)} units",
                  ),
                  _buildDetailRow(
                    "Actual Cost",
                    "\$${conversion.outputProductBatch!.realCost.toStringAsFixed(2)}",
                  ),
                  _buildDetailRow(
                    "Status",
                    conversion.outputProductBatch!.status.toUpperCase(),
                  ),
                  if (conversion.outputProductBatch!.notes != null &&
                      conversion.outputProductBatch!.notes!.isNotEmpty)
                    _buildDetailRow(
                      "Notes",
                      conversion.outputProductBatch!.notes!,
                    ),
                ],
              ),
            const SizedBox(height: 16),

            // Raw Material Batch Details
            if (conversion.rawMaterialBatch != null)
              _buildDetailCard(
                title: "Raw Material Used",
                icon: Icons.raw_on,
                children: [
                  _buildDetailRow(
                    "Material Name",
                    conversion.rawMaterialBatch!.rawMaterial?.name ?? "N/A",
                  ),
                  _buildDetailRow(
                    "Unit Price",
                    "\$${conversion.rawMaterialBatch!.rawMaterial?.price.toStringAsFixed(2)}",
                  ),
                  _buildDetailRow(
                    "Payment Method",
                    conversion.rawMaterialBatch!.paymentMethod,
                  ),
                  _buildDetailRow(
                    "Supplier",
                    conversion.rawMaterialBatch!.supplier,
                  ),
                  _buildDetailRow(
                    "Remaining Quantity",
                    "${conversion.rawMaterialBatch!.quantityRemaining.toStringAsFixed(2)} units",
                  ),
                  if (conversion.rawMaterialBatch!.notes != null &&
                      conversion.rawMaterialBatch!.notes!.isNotEmpty)
                    _buildDetailRow(
                      "Notes",
                      conversion.rawMaterialBatch!.notes!,
                    ),
                ],
              ),
            const SizedBox(height: 16),

            // Input Product Batch Details
            if (conversion.inputProductBatch != null)
              _buildDetailCard(
                title: "Input Product",
                icon: Icons.input,
                children: [
                  _buildDetailRow(
                    "Product Name",
                    conversion.inputProductBatch!.product?.name ?? "N/A",
                  ),
                  _buildDetailRow(
                    "Actual Cost",
                    "\$${conversion.inputProductBatch!.realCost.toStringAsFixed(2)}",
                  ),
                  if (conversion.inputProductBatch!.notes != null &&
                      conversion.inputProductBatch!.notes!.isNotEmpty)
                    _buildDetailRow(
                      "Notes",
                      conversion.inputProductBatch!.notes!,
                    ),
                ],
              ),
            const SizedBox(height: 24),

            // Timestamps
            _buildTimestampsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              conversion.batchType == 'raw_material'
                  ? Icons.raw_on
                  : Icons.autorenew,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              "Conversion ProductBatch #${conversion.conversionId}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                conversion.batchType.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: conversion.batchType == 'raw_material'
                  ? Colors.blue.shade600
                  : Colors.green.shade600,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple.shade700),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestampsCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Created At",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  conversion.createdAt.toLocal().toString().split(' ')[0],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Last Updated",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  conversion.updatedAt.toLocal().toString().split(' ')[0],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
