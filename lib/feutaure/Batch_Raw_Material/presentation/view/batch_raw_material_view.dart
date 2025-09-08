// raw_material_batches_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_get/get_batch_raw_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_get/get_batch_raw_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/update_batch_raw_material.dart'
    show UpdateBatchRawMaterial;
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/widget/card_raw_material_batch.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart';

class RawMaterialBatchesListScreen extends StatelessWidget {
  const RawMaterialBatchesListScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RawMaterialBatchesListCubit(
            RawMaterialBatchRepository(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'All RawMaterial Batch',
          ),
        ),
        body: BlocListener<AddRawMaterialBatchCubit, AddRawMaterialBatchState>(
          listener: (context, state) {
            if (state is AddRawMaterialBatchSuccess) {
              context
                  .read<RawMaterialBatchesListCubit>()
                  .fetchRawMaterialBatches();
            }
          },
          child: BathcRawMaterialBody(),
        ),
      ),
    );
  }
}

class BathcRawMaterialBody extends StatefulWidget {
  const BathcRawMaterialBody({super.key});

  @override
  State<BathcRawMaterialBody> createState() => _BathcRawMaterialBodyState();
}

class _BathcRawMaterialBodyState extends State<BathcRawMaterialBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RawMaterialBatchesListCubit>().fetchRawMaterialBatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      UpdateBatchRawMaterialCubit,
      UpdateBatchRawMaterialState
    >(
      listener: (context, state) {
        if (state is DeleatBatchRawMaterialSuccess ||
            state is UpdateBatchRawMaterialSuccess) {
          context.read<RawMaterialBatchesListCubit>().fetchRawMaterialBatches();
        }
        if (state is DeleatBatchRawMaterialError) {
          showCustomSnackBar(
            context,
            state.message,
            color: Palette.primaryError,
          );
        }
        if (state is DeleatBatchRawMaterialSuccess) {
          showCustomSnackBar(
            context,
            state.message,
            color: Palette.primarySuccess,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: RefreshIndicator(
          onRefresh: () async {
            await context
                .read<RawMaterialBatchesListCubit>()
                .fetchRawMaterialBatches();
          },
          color: Colors.indigo,
          child:
              BlocConsumer<
                RawMaterialBatchesListCubit,
                RawMaterialBatchesListState
              >(
                listener: (context, state) {
                  if (state is RawMaterialBatchesListError) {
                    // ... (show error snackbar)
                  }
                },
                builder: (context, state) {
                  if (state is RawMaterialBatchesListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.indigo),
                    );
                  } else if (state is RawMaterialBatchesListLoaded) {
                    if (state.batches.isEmpty) {
                      // ... (Empty state UI)
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.batches.length,
                      itemBuilder: (context, index) {
                        final batch = state.batches[index];
                        final isLowStock =
                            batch.quantityRemaining <=
                            batch.rawMaterial.minimumStockAlert;

                        return BlocBuilder<
                          UpdateBatchRawMaterialCubit,
                          UpdateBatchRawMaterialState
                        >(
                          builder: (context, updateState) {
                            final isDeleting =
                                updateState is DeleatBatchRawMaterialLoading;
                            // updateState.batchId == batch.rawMaterialId;

                            return RawMaterialBatchCard(
                              batchId: batch.rawMaterialBatchId,
                              rawMaterialName: batch.rawMaterial.name,
                              quantityIn: batch.quantityIn,
                              quantityOut: batch.quantityOut,
                              quantityRemaining: batch.quantityRemaining,
                              realCost: batch.realCost,
                              supplier: batch.supplier,
                              paymentMethod: batch.paymentMethod,
                              notes: batch.notes,
                              createdAt: batch.createdAt,
                              updatedAt: batch.updatedAt,
                              rawMaterialDescription:
                                  batch.rawMaterial.description,
                              rawMaterialPrice: batch.rawMaterial.price,
                              rawMaterialStatus: batch.rawMaterial.status,
                              minimumStockAlert:
                                  batch.rawMaterial.minimumStockAlert,
                              isLowStock: isLowStock,
                              isDeleting: isDeleting,
                              onEditPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateBatchRawMaterial(
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
                                                    .read<
                                                      UpdateBatchRawMaterialCubit
                                                    >()
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
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
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
                    );
                  } else if (state is RawMaterialBatchesListError) {
                    // ... (error display logic)
                  }
                  // Default state
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 100,
                          color: Colors.blueGrey[300],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }
}
