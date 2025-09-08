import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/conv_damae_sals.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/manager/getallProductbatch_Cubit/all_lproduct_batch_cubit.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/manager/getallProductbatch_Cubit/get_all_product_batch_state.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/widget/card_product_batch.dart';

class ProductBatchListView extends StatefulWidget {
  const ProductBatchListView({super.key});

  @override
  State<ProductBatchListView> createState() => _ProductBatchListViewState();
}

class _ProductBatchListViewState extends State<ProductBatchListView> {
  @override
  void initState() {
    super.initState();
    // Fetch all batches when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBatchCubit>().fetchAllProductBatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'All Product Batches',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProductBatchCubit>().fetchAllProductBatches();
        },
        color: Colors.indigo,
        child: BlocConsumer<ProductBatchCubit, ProductBatchState>(
          listener: (context, state) {
            if (state is ProductBatchError) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductBatchLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.indigo),
              );
            } else if (state is ProductBatchLoaded) {
              if (state.batches.isEmpty) {
                return const Center(child: Text('No batches found.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.batches.length,
                itemBuilder: (context, index) {
                  final batch = state.batches[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductBatchControlScreen(
                            id: batch.productBatchId,
                          ),
                        ),
                      );
                    },
                    child: ProductCard(batch: batch),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
