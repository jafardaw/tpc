import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/profit-loss-report/data/model/profit_loss_report_model.dart';

class ProfitLossDetailScreen extends StatelessWidget {
  final ProfitLossReportModel report;

  const ProfitLossDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final isProfit = report.type == 'profit';
    final primaryColor = isProfit ? Colors.green[700]! : Colors.red[700]!;
    final icon = isProfit ? Icons.trending_up : Icons.trending_down;
    final chartData = _prepareChartData(report);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: isProfit ? 'Profit Report Details' : 'Loss Report Details',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with animated chart
            _buildHeaderSection(context, primaryColor, icon, chartData),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Summary cards
                  _buildSummaryCards(report),
                  const SizedBox(height: 20),

                  // Detailed sections
                  _buildDetailsSection(context, report, primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    Color primaryColor,
    IconData icon,
    List<ChartData> chartData,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Animated chart
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(isVisible: false),
              primaryYAxis: NumericAxis(isVisible: false),
              series: <CartesianSeries>[
                AreaSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.5),
                      primaryColor.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderColor: Colors.white,
                  borderWidth: 2,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    borderWidth: 2,
                    borderColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Report summary
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 32, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        report.type,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Report #${report.reportId}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_US',
                      symbol: '\$',
                      decimalDigits: 2,
                    ).format(report.netProfitLoss),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(report.createdAt),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(ProfitLossReportModel report) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Type',
            value: report.type.toUpperCase(),
            icon: report.type == 'profit'
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: report.type == 'profit'
                ? Colors.green[700]!
                : Colors.red[700]!,
          ),
        ),
        const SizedBox(width: 12),
        if (report.productSale != null) ...[
          Expanded(
            child: _buildSummaryCard(
              title: 'Revenue',
              value: NumberFormat.currency(
                symbol: '\$',
              ).format(report.productSale!.revenue),
              icon: Icons.attach_money,
              color: Colors.blue[700]!,
            ),
          ),
        ],
        if (report.damagedMaterial != null) ...[
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Lost Cost',
              value: NumberFormat.currency(
                symbol: '\$',
              ).format(report.damagedMaterial!.lostCost),
              icon: Icons.money_off,
              color: Colors.orange[700]!,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(
    BuildContext context,
    ProfitLossReportModel report,
    Color primaryColor,
  ) {
    return Column(
      children: [
        if (report.productSale != null) ...[
          _buildDetailCard(
            title: 'Sale Details',
            icon: Icons.shopping_cart,
            color: Colors.blue[700]!,
            children: [
              _buildDetailRow(
                'Product',
                report.productSale!.productBatch?.product?.name ?? 'Unknown',
              ),
              _buildDetailRow(
                'Quantity Sold',
                report.productSale!.quantitySold.toString(),
              ),
              _buildDetailRow('Customer', report.productSale!.customer),
              _buildDetailRow(
                'Revenue',
                NumberFormat.currency(
                  symbol: '\$',
                ).format(report.productSale!.revenue),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (report.damagedMaterial != null) ...[
          _buildDetailCard(
            title: 'Damage Details',
            icon: Icons.warning,
            color: Colors.orange[700]!,
            children: [
              _buildDetailRow(
                'Material Type',
                report.damagedMaterial!.materialType == 'semi'
                    ? 'Semi-Finished'
                    : 'Raw',
              ),
              _buildDetailRow(
                'Material',
                report.damagedMaterial!.productBatch?.product?.name ??
                    report
                        .damagedMaterial!
                        .rawMaterialBatch
                        ?.rawMaterial
                        ?.name ??
                    'Unknown',
              ),
              _buildDetailRow(
                'Damaged Quantity',
                report.damagedMaterial!.quantity.toString(),
              ),
              _buildDetailRow(
                'Lost Cost',
                NumberFormat.currency(
                  symbol: '\$',
                ).format(report.damagedMaterial!.lostCost),
              ),
              if (report.damagedMaterial!.notes != null &&
                  report.damagedMaterial!.notes!.isNotEmpty)
                _buildDetailRow('Notes', report.damagedMaterial!.notes!),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (report.notes != null && report.notes!.isNotEmpty) ...[
          _buildDetailCard(
            title: 'Report Notes',
            icon: Icons.notes,
            color: Colors.purple[700]!,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  report.notes!,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 15,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  List<ChartData> _prepareChartData(ProfitLossReportModel report) {
    // This creates dummy data for the chart animation
    // Replace with your actual data if available
    return [
      ChartData('Jan', report.netProfitLoss * 0.2),
      ChartData('Feb', report.netProfitLoss * 0.4),
      ChartData('Mar', report.netProfitLoss * 0.6),
      ChartData('Apr', report.netProfitLoss * 0.8),
      ChartData('May', report.netProfitLoss),
    ];
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime.toLocal());
    } catch (e) {
      return dateString;
    }
  }
}

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}
