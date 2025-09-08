import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/empty_widget_view.dart';
import 'package:tcp212/core/widget/error_widget_view.dart';
import 'package:tcp212/feutaure/conversions/data/model/conversions_model.dart';
import 'package:tcp212/feutaure/conversions/data/model/product_conversion_model.dart';
import 'package:tcp212/feutaure/conversions/presentation/manger/cubit/conversions_cubit.dart';
import 'package:tcp212/feutaure/conversions/presentation/manger/cubit/conversions_state.dart';
import 'package:tcp212/feutaure/conversions/repo/conversion_repo.dart';

class ProductBatchConversionsScreen extends StatelessWidget {
  final int productBatchId;

  const ProductBatchConversionsScreen({
    super.key,
    required this.productBatchId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ConversionsCubit(repository: ConversionsRepoImpl(ApiService()))
            ..getConversionsByProductBatch(productBatchId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F8),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'تحويلات دفعة المنتج #$productBatchId',
          ),
        ),
        body: BlocBuilder<ConversionsCubit, ConversionsState>(
          builder: (context, state) {
            if (state is ConversionBatchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ConversionBatchLoaded) {
              if (state.conversions.isEmpty) {
                return const EmptyWigetView(
                  message: 'لا توجد تحويلات لهذه الدفعة.',
                  icon: Icons.search_off_outlined,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                itemCount: state.conversions.length,
                itemBuilder: (context, index) {
                  final conversion = state.conversions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ConversionCard(conversion: conversion),
                  );
                },
              );
            } else if (state is ConversionBatchError) {
              return ErrorWidetView(message: 'حدث خطأ: ${state.message}');
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class ConversionCard extends StatelessWidget {
  final ConversionModel conversion;

  const ConversionCard({super.key, required this.conversion});

  @override
  Widget build(BuildContext context) {
    Color batchColor;
    String batchLabel;

    if (conversion.batchType == 'raw_material') {
      batchColor = Colors.orange;
      batchLabel = 'مادة خام';
    } else {
      batchColor = Colors.blue;
      batchLabel = 'منتج';
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تحويل #${conversion.conversionId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: batchColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      batchLabel,
                      style: TextStyle(
                        color: batchColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.attach_money,
                label: 'التكلفة الإجمالية:',
                value: '${conversion.cost} \$',
              ),
              _buildInfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'تاريخ التحويل:',
                value: conversion.createdAt.toString().split(' ')[0],
              ),
              const SizedBox(height: 24),
              if (conversion.rawMaterialBatch != null) ...[
                _buildNestedBatchInfo(
                  title: 'تفاصيل المادة الخام',
                  batch: conversion.rawMaterialBatch!,
                ),
              ],
              if (conversion.inputProductBatch != null) ...[
                _buildNestedBatchInfo(
                  title: 'تفاصيل المنتج المدخل',
                  batch: conversion.inputProductBatch!,
                ),
              ],
              if (conversion.outputProductBatch != null) ...[
                _buildNestedBatchInfo(
                  title: 'تفاصيل المنتج المخرج',
                  batch: conversion.outputProductBatch!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: Colors.blueGrey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNestedBatchInfo({
    required String title,
    required dynamic batch,
  }) {
    String batchDetails = '';
    String? price;
    String? name;
    IconData batchIcon;

    if (batch is ProductBatchConvirsionsModel) {
      batchDetails =
          'كمية الدخول: ${batch.quantityIn}, كمية الخروج: ${batch.quantityOut}';
      price = 'التكلفة الفعلية: ${batch.realCost}';
      name = batch.product?.name;
      batchIcon = Icons.production_quantity_limits_outlined;
    } else if (batch is RawMaterialBatchConversionModel) {
      batchDetails =
          'كمية الدخول: ${batch.quantityIn}, كمية الخروج: ${batch.quantityOut}';
      price = 'التكلفة الفعلية: ${batch.realCost}';
      name = batch.rawMaterial?.name;
      batchIcon = Icons.inventory_2_outlined;
    } else {
      batchDetails = 'لا توجد بيانات متاحة.';
      batchIcon = Icons.error_outline;
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(batchIcon, size: 24, color: Colors.indigo),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Colors.grey),
          const SizedBox(height: 8),
          if (name != null)
            _buildNestedDetailRow(
              icon: Icons.label_important_outline,
              label: 'الاسم:',
              value: name,
            ),
          _buildNestedDetailRow(
            icon: Icons.swap_horiz,
            label: 'الكميات:',
            value: batchDetails,
          ),
          if (price != null)
            _buildNestedDetailRow(
              icon: Icons.attach_money_outlined,
              label: 'التكلفة الفعلية:',
              value: price,
            ),
          if (batch.notes != null && batch.notes!.isNotEmpty)
            _buildNestedDetailRow(
              icon: Icons.sticky_note_2_outlined,
              label: 'ملاحظات:',
              value: batch.notes!,
            ),
        ],
      ),
    );
  }

  Widget _buildNestedDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.green[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
