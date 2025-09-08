import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_allbatch/getallbatchforrawmaterial_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_allbatch/getallbatchforrawmaterial_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/update_batch_raw_material.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/widget/card_raw_material_batch.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart';

class GetAllBatchForRowmaterialId extends StatelessWidget {
  final int rawMaterialId;
  final String namerawmaterial;
  final String rawMaterialStatus;
  final double rawMaterialPrice;
  final String rawMaterialDescription;
  final int minimumStockAlert;

  const GetAllBatchForRowmaterialId({
    super.key,
    required this.rawMaterialId,
    required this.namerawmaterial,
    required this.rawMaterialPrice,
    required this.rawMaterialStatus,
    required this.rawMaterialDescription,
    required this.minimumStockAlert,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllBatchRawMaterialCubit(
        rawMaterialRepo: RawMaterialBatchRepository(ApiService()),
      )..getAllBatch(rawMaterialId: rawMaterialId),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'All Batch for Rowmaterial',
          ),
        ),
        body: BodyAllBatchForRawMaterial(
          rawMaterialDescription: rawMaterialDescription,
          rawMaterialPrice: rawMaterialPrice,
          rawMaterialId: rawMaterialId,
          namerawmaterial: namerawmaterial,
          rawMaterialStatus: rawMaterialStatus,
          minimumStockAlert: minimumStockAlert,
        ),
      ),
    );
  }
}

class BodyAllBatchForRawMaterial extends StatelessWidget {
  final int rawMaterialId;
  final int minimumStockAlert;

  final double rawMaterialPrice;
  final String namerawmaterial;
  final String rawMaterialStatus;
  final String rawMaterialDescription;

  const BodyAllBatchForRawMaterial({
    super.key,
    required this.rawMaterialId,
    required this.namerawmaterial,
    required this.rawMaterialPrice,
    required this.rawMaterialStatus,
    required this.rawMaterialDescription,
    required this.minimumStockAlert,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllBatchRawMaterialCubit, AllBatchRawMaterialState>(
      builder: (context, state) {
        if (state is AllBatchRawMaterialLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllBatchRawMaterialSuccess) {
          final batches = state.batches;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: batches.length,
              itemBuilder: (context, index) {
                final batch = batches[index];

                final isLowStock = batch.quantityRemaining <= minimumStockAlert;

                return BlocBuilder<
                  UpdateBatchRawMaterialCubit,
                  UpdateBatchRawMaterialState
                >(
                  builder: (context, updateState) {
                    final isDeleting =
                        updateState is DeleatBatchRawMaterialLoading;
                    return RawMaterialBatchCard(
                      batchId: batch.rawMaterialBatchId,
                      rawMaterialName: namerawmaterial,
                      quantityIn: batch.quantityIn,
                      quantityOut: batch.quantityOut,
                      quantityRemaining: batch.quantityRemaining,
                      realCost: batch.realCost,
                      supplier: batch.supplier,
                      paymentMethod: batch.paymentMethod,
                      notes: batch.notes,
                      createdAt: batch.updatedAt,
                      updatedAt: batch.updatedAt,
                      rawMaterialDescription: rawMaterialDescription,
                      rawMaterialPrice: rawMaterialPrice,
                      rawMaterialStatus: rawMaterialStatus,
                      minimumStockAlert: minimumStockAlert,
                      isLowStock: isLowStock,
                      isDeleting: isDeleting,
                      onEditPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateBatchRawMaterialBody2(
                              rawMaterialBatchModel: batch,
                            ),
                          ),
                        );
                      },
                      onDeletePressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('تأكيد الحذف'),
                            content: const Text(
                              'هل أنت متأكد من رغبتك في حذف هذه المادة؟',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('إلغاء'),
                              ),
                              TextButton(
                                onPressed: isDeleting
                                    ? null
                                    : () {
                                        context
                                            .read<UpdateBatchRawMaterialCubit>()
                                            .deleatBatchRawMaterial(
                                              batch.rawMaterialId,
                                            );
                                        Navigator.pop(
                                          context,
                                        ); // إغلاق الـ dialog
                                      },
                                child: isDeleting
                                    ? const CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: Colors.red,
                                      )
                                    : const Text(
                                        'حذف',
                                        style: TextStyle(color: Colors.red),
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        } else if (state is AllBatchRawMaterialFailure) {
          return Center(child: Text(state.errMessage));
        }
        return const Center(child: Text("No data found"));
      },
    );
  }
}

// lib/feature/raw_materials/widget/batch_item_widget.dart

// class BatchItemWidget extends StatelessWidget {
//   final RawMaterialBatch batch;
//   const BatchItemWidget({super.key, required this.batch});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Batch ID: ${batch.rawMaterialBatchId}",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("Supplier: ${batch.supplier}"),
//             Text("Quantity In: ${batch.quantityIn}"),
//             Text("Quantity Out: ${batch.quantityOut}"),
//             Text("Quantity Remaining: ${batch.quantityRemaining}"),
//             Text("Cost: ${batch.realCost} \$"),
//             Text("Notes: ${batch.notes}"),
//             // Text("Created At: ${batch.createdAt.split('T')[0]}"),
//           ],
//         ),
//       ),
//     );
//   }
// }
