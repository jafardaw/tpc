import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/conv_damae_sals.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/manager/getallProductbatch_Cubit/all_lproduct_batch_cubit.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/manager/getallProductbatch_Cubit/get_all_product_batch_state.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/widget/card_product_batch_by_id.dart';

class ProductBatchListByidView extends StatefulWidget {
  const ProductBatchListByidView({
    super.key,
    required this.id,
    required this.name,
  });
  final int id;
  final String name;
  @override
  State<ProductBatchListByidView> createState() =>
      _ProductBatchListByidViewState();
}

class _ProductBatchListByidViewState extends State<ProductBatchListByidView> {
  @override
  void initState() {
    super.initState();
    // Fetch all batches when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBatchCubit>().fetchProductBatchesById(widget.id);
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
          title: 'Product Batches',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProductBatchCubit>().fetchProductBatchesById(
            widget.id,
          );
        },
        color: Colors.indigo,
        child: BlocConsumer<ProductBatchCubit, ProductBatchState>(
          listener: (context, state) {
            if (state is ProductBatchByidError) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductBatchByidLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.indigo),
              );
            } else if (state is ProductBatchByidLoaded) {
              if (state.props.isEmpty) {
                return const Center(child: Text('No batches found.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.props.length,
                itemBuilder: (context, index) {
                  final batch = state.response.data[index];
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
                    child: ProductCardByid(batch: batch, name: widget.name),
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
