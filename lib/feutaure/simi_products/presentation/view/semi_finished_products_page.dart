import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/simi_products/presentation/manger/semi_finished_products_cubit.dart';
import 'package:tcp212/feutaure/simi_products/presentation/view/widget/simi_product_card.dart';

class SemiFinishedProductsPage extends StatefulWidget {
  const SemiFinishedProductsPage({super.key});

  @override
  State<SemiFinishedProductsPage> createState() =>
      _SemiFinishedProductsPageState();
}

class _SemiFinishedProductsPageState extends State<SemiFinishedProductsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SemiFinishedProductsCubit>(
      context,
    ).getSemiFinishedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Semi-Finished Products',
        ),
      ),
      body: BlocBuilder<SemiFinishedProductsCubit, SemiFinishedProductsState>(
        builder: (context, state) {
          if (state is SemiFinishedProductsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          } else if (state is SemiFinishedProductsLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return SimiProductCard(product: product);
              },
            );
          } else if (state is SemiFinishedProductsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        BlocProvider.of<SemiFinishedProductsCubit>(
                          context,
                        ).getSemiFinishedProducts();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink(); // Initial state
        },
      ),
    );
  }
}
