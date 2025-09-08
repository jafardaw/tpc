// في ملف: tcp/feutaure/ProductSaleReports/presentation/screen/product_report_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcp212/feutaure/ProductSaleReports/data/model/product_summary_report_model.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/manger/cubit/cubit/product_summary_report_cubit.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/manger/cubit/cubit/product_summary_report_state.dart';

class ProductReportDetailsScreen extends StatelessWidget {
  final ProductSummaryReportModel report;

  const ProductReportDetailsScreen({super.key, required this.report});

  void _onRefresh(BuildContext context) {
    final cubit = BlocProvider.of<ProductSummaryReportCubit>(context);
    cubit.refreshSingleReport(report.reportId);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('يتم تحديث التقرير...')));
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'ar', symbol: 'د.ك');
    final profitColor = report.netProfit >= 0
        ? Colors.green[700]
        : Colors.red[700];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          title: report.product?.name ?? 'تفاصيل التقرير',
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => _onRefresh(context),
            ),
          ],
        ),
      ),
      body: BlocListener<ProductSummaryReportCubit, ProductSummaryReportState>(
        listener: (context, state) {
          if (state is ProductSummaryReportLoading) {
            CircularProgressIndicator();
          }
          if (state is ProductSummaryReportLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث التقرير بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProductSummaryReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل التحديث: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        report.netProfit >= 0
                            ? Icons.trending_up
                            : Icons.trending_down,
                        color: profitColor,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'الربح الصافي',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatter.format(report.netProfit),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: profitColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailCard(context, 'تفاصيل المبيعات والإنتاج', [
                _buildInfoRow(
                  context,
                  'الكمية المنتجة:',
                  '${report.quantityProduced}',
                ),
                _buildInfoRow(
                  context,
                  'الكمية المباعة:',
                  '${report.quantitySold}',
                ),
              ]),
              const SizedBox(height: 16),
              _buildDetailCard(context, 'التفاصيل المالية', [
                _buildInfoRow(
                  context,
                  'إجمالي التكاليف:',
                  formatter.format(report.totalCosts),
                ),
                _buildInfoRow(
                  context,
                  'إجمالي الدخل:',
                  formatter.format(report.totalIncome),
                  valueColor: Colors.blue[700],
                ),
              ]),
              if (report.notes != null && report.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildDetailCard(context, 'ملاحظات إضافية', [
                  Text(
                    report.notes!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ]),
              ],
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'تاريخ التقرير: ${_formatDate(report.createdAt)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal());
    } catch (e) {
      return dateString;
    }
  }
}
