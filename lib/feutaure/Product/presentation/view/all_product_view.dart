import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/alert_dilog.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/util/styles.dart';
import 'package:tcp212/core/widget/appar_widget,.dart'; // Assuming this exists
import 'package:tcp212/core/widget/cusrom_button_card.dart';
import 'package:tcp212/feutaure/Product/data/get_all_product_model.dart';
import 'package:tcp212/feutaure/Product/presentation/view/add_new_producr.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/cubit_update/update_product_cubit.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/cubit_update/update_product_state.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/get_cubit/get_all_product_cubit.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/get_cubit/get_all_product_state.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/update_price_cubit/cubit/updateproductprice_cubit.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/product_batch_for_by_id.dart';
import 'package:tcp212/feutaure/productmaterial/presentation/view/widget/product_raw_material_by_id.dart';
import 'package:tcp212/feutaure/productmaterial/repo/repo_product_material.dart';
import 'package:tcp212/product_patch_J/presentation/view/create_product_batch_page.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductListCubit>().fetchProducts();
    });
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, size: 18, color: iconColor ?? Colors.grey[600]),
          if (icon != null) const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProductCubit, UpdateProductState>(
      listener: (context, state) {
        if (state is DeleatProductSuccess) {
          showCustomSnackBar(
            context,
            state.message,
            color: Palette.primarySuccess,
          );
          context.read<ProductListCubit>().fetchProducts();
        }
        if (state is DeleatroductError) {
          showCustomSnackBar(
            context,
            state.message,
            color: Palette.primaryError,
          );
        }
      },
      child: BlocConsumer<UpdateproductpriceCubit, UpdateproductpriceState>(
        listener: (context, state) {
          if (state is UpdateproductpriceSucsess) {
            showCustomSnackBar(
              context,
              state.message,
              color: Palette.primarySuccess,
            );
            context.read<ProductListCubit>().fetchProducts();
          } else if (state is UpdateproductpriceError) {
            showCustomSnackBar(
              context,
              state.message,
              color: Palette.primaryError,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppareWidget(
                actions: [
                  IconButton(
                    onPressed: () {
                      context
                          .read<UpdateproductpriceCubit>()
                          .updateProducePrice();
                    },
                    icon: Icon(Icons.refresh_sharp),
                  ),
                ],
                automaticallyImplyLeading:
                    true, // Set to false if this is a root page
                title: 'Products List',
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await context.read<ProductListCubit>().fetchProducts();
              },
              color: Colors.indigo,
              child: BlocConsumer<ProductListCubit, ProductListState>(
                listener: (context, state) {
                  if (state is ProductListError) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${state.errorMessage}'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ProductListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.indigo),
                    );
                  } else if (state is ProductListLoaded) {
                    if (state.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.widgets_outlined,
                              size: 100,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No products to display at the moment.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<ProductListCubit>()
                                    .fetchProducts();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[800],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  ProductMaterialsByIDCubit(
                                                    ProductMaterialsRepo(
                                                      ApiService(),
                                                    ),
                                                  ),
                                              child: ProductRawMaterialById(
                                                id: product.productId,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.fact_check),
                                      color: Colors.blue,
                                      tooltip: 'product materiall',
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  ProductMaterialsByIDCubit(
                                                    ProductMaterialsRepo(
                                                      ApiService(),
                                                    ),
                                                  ),
                                              child: CreateProductBatchPage(
                                                productId: product.productId,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.add),
                                      color: Colors.blue,
                                      tooltip: 'add batch',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: Colors.indigo,
                                ),
                                const SizedBox(height: 15),

                                // _buildInfoRow('Description', product.description,
                                //     icon: Icons.description,
                                //     iconColor: Colors.blueGrey),
                                _buildInfoRow(
                                  'Category',
                                  product.category,
                                  icon: Icons.category,
                                  iconColor: Colors.deepPurple,
                                ),
                                _buildInfoRow(
                                  'Price',
                                  '${product.price} SAR',
                                  icon: Icons.attach_money,
                                  iconColor: Colors.green,
                                ),
                                _buildInfoRow(
                                  'Weight per Unit',
                                  '${product.weightPerUnit} kg',
                                  icon: Icons.scale,
                                  iconColor: Colors.brown,
                                ),
                                _buildInfoRow(
                                  'Minimum Stock Alert',
                                  '${product.minimumStockAlert}',
                                  icon: Icons.notifications_active,
                                  iconColor: Colors.red,
                                ),

                                if (product.imagePath != null &&
                                    product.imagePath!.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Image.network(
                                    'http://127.0.0.1:8000/${product.imagePath!}', // Adjust base URL if needed
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                  ),
                                ],

                                const SizedBox(height: 15),
                                const Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 15),

                                // Product Materials Section
                                Text(
                                  'Materials Required:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blueGrey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (product.productMaterials.isEmpty)
                                  Text(
                                    'No materials specified.',
                                    style: TextStyle(color: Colors.grey[600]),
                                  )
                                else
                                  ...product.productMaterials.map((material) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        bottom: 4.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.indigo,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              '${material.componentType.replaceAll('_', ' ')}: '
                                              '${material.getRawMaterialModel?.name ?? material.simiProductModel?.name ?? "N/A"}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),

                                const SizedBox(height: 15),
                                const Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Added: ${DateFormat('yyyy-MM-dd HH:mm').format(product.createdAt.toLocal())}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      'Updated: ${DateFormat('yyyy-MM-dd HH:mm').format(product.updatedAt.toLocal())}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10),

                                // Action Buttons: Edit and Delete
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 24,
                                      ),
                                      tooltip: 'batch',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductBatchListByidView(
                                                  id: product.productId,
                                                  name: product.name,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    Spacer(),
                                    // IconButton(
                                    //   icon: const Icon(Icons.edit,
                                    //       color: Colors.blue, size: 24),
                                    //   tooltip: 'Edit Product',
                                    //   onPressed: () {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             UpdateProductView(
                                    //                 product: product),
                                    //       ),
                                    //     );
                                    //   },
                                    // ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      tooltip: 'Delete Product',
                                      onPressed: () {
                                        _confirmDeleteProduct(context, product);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // Default state (ProductListInitial or unexpected state)
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
                            'Tap refresh to load products.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<ProductListCubit>().fetchProducts();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNewProduct()),
                );
              },
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  // Helper function for delete confirmation
  void _confirmDeleteProduct(BuildContext context, Product product) {
    showCustomAlertDialog(
      context: context,
      title: 'Alert!',
      content: 'Are you sure Delete ${product.name}?',
      actions: [
        ButtonINCard(
          onPressed: () {
            print('sssssssssssssssssssssssssss${product.productId}');
            Navigator.of(context).pop();

            context.read<UpdateProductCubit>().deleatProduct(product.productId);
          },
          icon: Icon(Icons.delete, color: Colors.red),
          label: Text(
            'delete',
            style: Styles.textStyle18.copyWith(color: Colors.white),
          ),
        ),
        ButtonINCard(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.cancel, color: Colors.green),
          label: Text(
            'cancel',
            style: Styles.textStyle18.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// // Extension to capitalize first letter of each word
// extension StringExtension on String {
//   String capitalizeFirstofEach() {
//     if (isEmpty) return this;
//     return split(' ').map((word) {
//       if (word.isEmpty) return '';
//       return word[0].toUpperCase() + word.substring(1).toLowerCase();
//     }).join(' ');
//   }
// }
