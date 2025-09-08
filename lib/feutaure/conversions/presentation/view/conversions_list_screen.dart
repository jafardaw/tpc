import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/empty_widget_view.dart';
import 'package:tcp212/core/widget/error_widget_view.dart';
import 'package:tcp212/feutaure/conversions/presentation/manger/cubit/conversions_cubit.dart';
import 'package:tcp212/feutaure/conversions/presentation/manger/cubit/conversions_state.dart';
import 'package:tcp212/feutaure/conversions/presentation/view/conversions_details.dart';
import 'package:tcp212/feutaure/conversions/repo/conversion_repo.dart';

class ConversionsListScreen extends StatefulWidget {
  const ConversionsListScreen({super.key});

  @override
  State<ConversionsListScreen> createState() => _ConversionsListScreenState();
}

class _ConversionsListScreenState extends State<ConversionsListScreen> {
  late ConversionsCubit _conversionsCubit;

  @override
  void initState() {
    super.initState();
    _conversionsCubit = ConversionsCubit(
      repository: ConversionsRepoImpl(ApiService()),
    );
    _conversionsCubit.fetchAllConversions();
  }

  @override
  void dispose() {
    _conversionsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Conversions History',
        ),
      ),
      body: BlocProvider<ConversionsCubit>.value(
        value: _conversionsCubit,
        child: BlocConsumer<ConversionsCubit, ConversionsState>(
          listener: (context, state) {
            if (state is ConversionsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.errorMessage}')),
              );
            }
          },
          builder: (context, state) {
            if (state is ConversionsLoading || state is ConversionsInitial) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2.0),
              );
            } else if (state is ConversionsLoaded) {
              if (state.conversions.isEmpty) {
                return const EmptyWigetView(
                  message: 'No conversions to display.',
                  icon: Icons.sync_disabled,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: state.conversions.length,
                itemBuilder: (context, index) {
                  final conversion = state.conversions[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConversionDetailsScreen(conversion: conversion),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Conversion #${conversion.conversionId}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        conversion.batchType == 'raw_material'
                                        ? Colors.blue.shade600
                                        : Colors.green.shade600,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    conversion.batchType.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20, thickness: 1),
                            _buildInfoRow(
                              Icons.functions,
                              'Quantity Used:',
                              conversion.quantityUsed.toStringAsFixed(2),
                            ),
                            _buildInfoRow(
                              Icons.attach_money,
                              'Cost:',
                              conversion.cost.toStringAsFixed(2),
                            ),

                            // Output Product Batch details
                            if (conversion.outputProductBatch != null) ...[
                              const SizedBox(height: 15),
                              _buildSectionHeader('Output Product'),
                              _buildInfoRow(
                                Icons.inventory_2,
                                'Product Name:',
                                conversion.outputProductBatch!.product?.name ??
                                    'N/A',
                              ),
                              _buildInfoRow(
                                Icons.production_quantity_limits,
                                'Produced Quantity:',
                                conversion.outputProductBatch!.quantityIn
                                    .toStringAsFixed(2),
                              ),
                              _buildInfoRow(
                                Icons.paid,
                                'Batch Cost:',
                                conversion.outputProductBatch!.realCost
                                    .toStringAsFixed(2),
                              ),
                              _buildInfoRow(
                                Icons.category,
                                'Product Category:',
                                conversion
                                        .outputProductBatch!
                                        .product
                                        ?.category ??
                                    'N/A',
                              ),
                              if (conversion.outputProductBatch!.notes !=
                                      null &&
                                  conversion
                                      .outputProductBatch!
                                      .notes!
                                      .isNotEmpty)
                                _buildInfoRow(
                                  Icons.notes,
                                  'Batch Notes:',
                                  conversion.outputProductBatch!.notes!,
                                ),
                            ],

                            // Raw Material Batch details
                            if (conversion.rawMaterialBatch != null) ...[
                              const SizedBox(height: 15),
                              _buildSectionHeader('Raw Material Used'),
                              _buildInfoRow(
                                Icons.category_outlined,
                                'Raw Material Name:',
                                conversion
                                        .rawMaterialBatch!
                                        .rawMaterial
                                        ?.name ??
                                    'N/A',
                              ),
                              _buildInfoRow(
                                Icons.attach_money_outlined,
                                'Unit Price:',
                                '${conversion.rawMaterialBatch!.rawMaterial?.price.toStringAsFixed(2)}',
                              ),
                              _buildInfoRow(
                                Icons.money,
                                'Payment Method:',
                                conversion.rawMaterialBatch!.paymentMethod,
                              ),
                              _buildInfoRow(
                                Icons.local_shipping,
                                'Supplier:',
                                conversion.rawMaterialBatch!.supplier,
                              ),
                              if (conversion.rawMaterialBatch!.notes != null &&
                                  conversion
                                      .rawMaterialBatch!
                                      .notes!
                                      .isNotEmpty)
                                _buildInfoRow(
                                  Icons.notes,
                                  'Batch Notes:',
                                  conversion.rawMaterialBatch!.notes!,
                                ),
                            ],

                            // Input Product Batch details (if exists)
                            if (conversion.inputProductBatch != null) ...[
                              const SizedBox(height: 15),
                              _buildSectionHeader('Input Product'),
                              _buildInfoRow(
                                Icons.input,
                                'Input Product Name:',
                                conversion.inputProductBatch!.product?.name ??
                                    'N/A',
                              ),
                              _buildInfoRow(
                                Icons.monetization_on,
                                'Input Batch Cost:',
                                conversion.inputProductBatch!.realCost
                                    .toStringAsFixed(2),
                              ),
                              if (conversion.inputProductBatch!.notes != null &&
                                  conversion
                                      .inputProductBatch!
                                      .notes!
                                      .isNotEmpty)
                                _buildInfoRow(
                                  Icons.notes,
                                  'Batch Notes:',
                                  conversion.inputProductBatch!.notes!,
                                ),
                            ],

                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Created At: ${conversion.createdAt.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Last Updated: ${conversion.updatedAt.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ConversionsError) {
              return Center(
                child: ErrorWidetView(
                  message: 'Error loading conversions: ${state.errorMessage}',
                  onPressed: () {
                    _conversionsCubit.fetchAllConversions(); // Retry
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Helper function to create an info row
  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? Colors.deepPurple.shade700),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: color ?? Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple.shade700,
        ),
      ),
    );
  }
}
