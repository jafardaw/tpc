import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/empty_widget_view.dart';
import 'package:tcp212/feutaure/profit-loss-report/data/model/profit_loss_report_model.dart';
import 'package:tcp212/feutaure/profit-loss-report/presentation/manger/cubit/profit_loss_cubit.dart';
import 'package:tcp212/feutaure/profit-loss-report/presentation/manger/cubit/profit_loss_state.dart';
import 'package:tcp212/feutaure/profit-loss-report/presentation/view/profit_loss_details_view.dart';
import 'package:tcp212/feutaure/profit-loss-report/repo/profit_loss_repository_imp.dart';

class ProfitLossReportScreen extends StatelessWidget {
  const ProfitLossReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfitLossCubit(ProfitLossRepositoryImp(ApiService()))
            ..fetchProfitLossReport(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'Profit & Loss Report',
          ),
        ),
        body: BlocBuilder<ProfitLossCubit, ProfitLossState>(
          builder: (context, state) {
            if (state is ProfitLossLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.deepPurple,
                ),
              );
            } else if (state is ProfitLossLoaded) {
              if (state.reports.isEmpty) {
                return EmptyWigetView(
                  message: 'No Profit/Loss Reports Available',
                  icon: Icons.hourglass_empty,
                );
              }

              final totalProfit = state.reports
                  .where((r) => r.type == 'profit')
                  .fold(0.0, (sum, item) => sum + item.netProfitLoss);

              final totalLoss = state.reports
                  .where((r) => r.type == 'loss')
                  .fold(0.0, (sum, item) => sum + item.netProfitLoss);

              final netTotal = totalProfit - totalLoss.abs();

              return Column(
                children: [
                  buildSummaryCards(totalProfit, totalLoss, netTotal),

                  _buildProfitLossChart(state.reports),

                  // Report List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.reports.length,
                      itemBuilder: (context, index) {
                        return _buildReportCard(context, state.reports[index]);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is ProfitLossError) {
              return _buildErrorState(context, state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget buildSummaryCards(double profit, double loss, double net) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Profit Card
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Profit',
              value: profit,
              icon: Icons.trending_up,
              color: Colors.green[700]!,
            ),
          ),
          const SizedBox(width: 12),

          // Loss Card
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Loss',
              value: loss,
              icon: Icons.trending_down,
              color: Colors.red[700]!,
            ),
          ),
          const SizedBox(width: 12),

          // Net Card
          Expanded(
            child: _buildSummaryCard(
              title: 'Net Total',
              value: net,
              icon: net >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: net >= 0 ? Colors.green[700]! : Colors.red[700]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat.currency(
                locale: 'en_US',
                symbol: '\$',
                decimalDigits: 2,
              ).format(value),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitLossChart(List<ProfitLossReportModel> reports) {
    // Group by month for the chart
    final monthlyData = <String, double>{
      'Jan': 0,
      'Feb': 0,
      'Mar': 0,
      'Apr': 0,
      'May': 0,
      'Jun': 0,
      'Jul': 0,
      'Aug': 0,
      'Sep': 0,
      'Oct': 0,
      'Nov': 0,
      'Dec': 0,
    };

    for (var report in reports) {
      try {
        final date = DateTime.parse(report.createdAt);
        final month = DateFormat('MMM').format(date);
        final value = report.type == 'profit'
            ? report.netProfitLoss
            : -report.netProfitLoss;
        monthlyData[month] = (monthlyData[month] ?? 0) + value;
      } catch (e) {
        continue;
      }
    }

    final chartData = monthlyData.entries.map((entry) {
      return ChartData(entry.key, entry.value);
    }).toList();

    return SizedBox(
      height: 220,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelRotation: -45,
              labelStyle: const TextStyle(fontSize: 10),
            ),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.currency(symbol: '\$'),
            ),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.month,
                yValueMapper: (ChartData data, _) => data.value,
                pointColorMapper: (ChartData data, _) =>
                    data.value >= 0 ? Colors.green[700] : Colors.red[700],
                borderRadius: BorderRadius.circular(4),
                width: 0.6,
              ),
            ],
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.x : \$point.y',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, ProfitLossReportModel report) {
    final isProfit = report.type == 'profit';
    final color = isProfit ? Colors.green[700] : Colors.red[700];
    final icon = isProfit ? Icons.trending_up : Icons.trending_down;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfitLossDetailScreen(report: report),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ExpansionTile(
          leading: Icon(icon, color: color, size: 32),
          title: Text(
            isProfit ? 'Profit Report' : 'Loss Report',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          subtitle: Text(
            _formatDate(report.createdAt),
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Text(
            NumberFormat.currency(
              locale: 'en_US',
              symbol: '\$',
              decimalDigits: 2,
            ).format(report.netProfitLoss),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Report ID', report.reportId.toString()),
                  _buildDetailRow('Type', isProfit ? 'Profit' : 'Loss'),
                  _buildDetailRow(
                    'Amount',
                    NumberFormat.currency(
                      locale: 'en_US',
                      symbol: '\$',
                      decimalDigits: 2,
                    ).format(report.netProfitLoss),
                    valueColor: color,
                  ),
                  _buildDetailRow('Date', _formatDate(report.createdAt)),
                  if (report.productSale != null) ...[
                    const Divider(height: 20),
                    const Text(
                      'SALE DETAILS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    _buildDetailRow(
                      'Product',
                      report.productSale!.productBatch?.product?.name ??
                          'Unknown',
                    ),
                    _buildDetailRow(
                      'Quantity Sold',
                      report.productSale!.quantitySold.toString(),
                    ),
                    _buildDetailRow(
                      'Revenue',
                      NumberFormat.currency(
                        symbol: '\$',
                      ).format(report.productSale!.revenue),
                    ),
                    _buildDetailRow('Customer', report.productSale!.customer),
                  ],
                  if (report.damagedMaterial != null) ...[
                    const Divider(height: 20),
                    const Text(
                      'DAMAGE DETAILS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
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
                      _buildDetailRow(
                        'Damage Notes',
                        report.damagedMaterial!.notes!,
                      ),
                  ],
                  if (report.notes != null && report.notes!.isNotEmpty) ...[
                    const Divider(height: 20),
                    const Text(
                      'REPORT NOTES',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        report.notes!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Error Loading Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProfitLossCubit>().fetchProfitLossReport();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
  final String month;
  final double value;

  ChartData(this.month, this.value);
}
