import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/manger/cubit/monthly_profit_cubit.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/manger/cubit/monthly_profit_state.dart';
import 'package:tcp212/feutaure/ProductSaleReports/repo/product_summary_repository_imp.dart';

class MonthlyProfitScreen extends StatelessWidget {
  const MonthlyProfitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MonthlyProfitCubit(ProductSummaryRepositoryImp(ApiService()))
            ..fetchMonthlyProfit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'Monthly Sales Report',
          ),
        ),
        body: BlocBuilder<MonthlyProfitCubit, MonthlyProfitState>(
          builder: (context, state) {
            if (state is MonthlyProfitLoading) {
              return _buildLoadingState();
            } else if (state is MonthlyProfitLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is MonthlyProfitError) {
              return _buildErrorState(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 3, color: Colors.teal),
          const SizedBox(height: 20),
          Text(
            'Loading Monthly Report...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, MonthlyProfitLoaded state) {
    final monthlyProfit = state.monthlyProfit;
    final isProfit = monthlyProfit.totalProfit >= 0.0;
    final profitColor = isProfit ? Palette.primary : Colors.red[700]!;
    final icon = isProfit ? Icons.trending_up : Icons.trending_down;

    // Sample data for the chart (replace with actual data)
    final chartData = [
      _ChartData('Week 1', 1200),
      _ChartData('Week 2', 1800),
      _ChartData('Week 3', 900),
      _ChartData('Week 4', 2100),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header Card
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        monthlyProfit.month,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: profitColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: 20, color: profitColor),
                            const SizedBox(width: 6),
                            Text(
                              isProfit ? 'Profit' : 'Loss',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: profitColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.currency(symbol: '\$'),
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<_ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (_ChartData data, _) => data.week,
                        yValueMapper: (_ChartData data, _) => data.amount,
                        color: profitColor,
                        borderRadius: BorderRadius.circular(4),
                        width: 0.6,
                        markerSettings: const MarkerSettings(isVisible: true),
                      ),
                    ],
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      format: 'point.x : \$point.y',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Summary Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.monetization_on, size: 30, color: profitColor),
                      const SizedBox(width: 12),
                      Text(
                        'Net Profit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_US',
                      symbol: '\$',
                      decimalDigits: 2,
                    ).format(monthlyProfit.totalProfit.abs()),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: profitColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isProfit ? 'Total monthly profit' : 'Total monthly loss',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Additional Metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Best Week',
                  value: '\$2,100',
                  icon: Icons.arrow_upward,
                  color: Palette.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Worst Week',
                  value: '\$900',
                  icon: Icons.arrow_downward,
                  color: Colors.red[700]!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Refresh Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  context.read<MonthlyProfitCubit>().fetchMonthlyProfit(),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, MonthlyProfitError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
            const SizedBox(height: 20),
            Text(
              'Failed to load report',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<MonthlyProfitCubit>().fetchMonthlyProfit(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
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
}

class _ChartData {
  final String week;
  final double amount;

  _ChartData(this.week, this.amount);
}
