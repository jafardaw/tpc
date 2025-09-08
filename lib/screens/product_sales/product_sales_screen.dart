import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tcp212/constants/style.dart';
import 'package:tcp212/core/util/app_router.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/view_models/product_sales_cubit/product_sales_cubit.dart';
import 'package:tcp212/view_models/product_sales_cubit/product_sales_state.dart';
import 'package:tcp212/widgets/product_sales_widget/product_sales_main_widget.dart';

class ProductSalesScreen extends StatelessWidget {
  const ProductSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductSalesCubit()..fetchProductSales(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar:
              // AppBar(
              //   actions: [
              //     IconButton(
              //         onPressed: () {
              //           final state = context.read<ProductSalesCubit>().state;
              //           final sales = state is ProductSalesLoaded
              //               ? state.productSales
              //               : <dynamic>[];
              //           showSearch(
              //               context: context, delegate: ProductSalesSearch(sales));
              //         },
              //         icon: Icon(
              //           Icons.search,
              //           size: 25,
              //           color: Colors.black,
              //         ))
              //   ],
              //   title: Text(
              //     "Product Sales ",
              //     style: AppTextStyles.calibri20SemiBoldBlack,
              //   ),
              //   backgroundColor: Color(0xff9AE3CE),
              //   centerTitle: true,
              // ),
              PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AppareWidget(
                  actions: [
                    IconButton(
                      onPressed: () {
                        final state = context.read<ProductSalesCubit>().state;
                        final sales = state is ProductSalesLoaded
                            ? state.productSales
                            : <dynamic>[];
                        showSearch(
                          context: context,
                          delegate: ProductSalesSearch(sales),
                        );
                      },
                      icon: Icon(Icons.search, size: 25),
                    ),
                  ],
                  automaticallyImplyLeading:
                      true, // Set to false if this is a root page
                  title: 'Product Sales',
                ),
              ),
          body: BlocBuilder<ProductSalesCubit, ProductSalesState>(
            builder: (context, state) {
              if (state is ProductSalesLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is ProductSalesError) {
                return Center(child: Text(state.message));
              } else if (state is ProductSalesLoaded) {
                if (state.productSales.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد مبيعات ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'لم يتم العثور على أي مبيعات  حالياً',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.productSales.length,
                  itemBuilder: (context, index) {
                    final sale = state.productSales[index];
                    final displayName = sale.product.name
                        .split(' ')
                        .take(3)
                        .join(' ');
                    String? imageUrl;
                    final nameLower = sale.product.name.toLowerCase();
                    if (nameLower.contains('medical') ||
                        nameLower.contains('syring')) {
                      imageUrl =
                          'https://static.vecteezy.com/system/resources/previews/060/423/706/non_2x/medical-syringe-with-needle-for-injections-isolated-on-a-clean-transparent-background-representing-healthcare-tools-free-png.png';
                    } else if (nameLower.contains('garden') ||
                        nameLower.contains('planter')) {
                      imageUrl =
                          'https://static.vecteezy.com/system/resources/thumbnails/049/668/258/small_2x/wooden-planter-box-with-fresh-herbs-and-greenery-on-a-transparent-background-png.png';
                    } else if (nameLower.contains('electronics')) {
                      imageUrl =
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPsnX9GwTHCvtz0Jd0gP9TsrNbbZgO_OJA4IRff-HkpqgVO3ICrkWlzxE_HTSw-OuQX2w&usqp=CAU';
                    } else if (nameLower.contains('container')) {
                      imageUrl =
                          'https://www.u-buy.com.ng/productimg/?image=aHR0cHM6Ly9tLm1lZGlhLWFtYXpvbi5jb20vaW1hZ2VzL0kvNzFSbGlSQURlREwuX0FDX1NMMTIwMF8uanBn.jpg';
                    } else if (nameLower.contains('pallets')) {
                      imageUrl =
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRY2lLtEV4oQJX6R2VUzx9BPrzeR7IDaaZKws6BxeaUur6OksEoodCBJ0Llavk3Q_NCyDw&usqp=CAU';
                    } else if (nameLower.contains('cable')) {
                      imageUrl =
                          'https://images-eu.ssl-images-amazon.com/images/I/61EtcBMUgYL._AC_UL495_SR435,495_.jpg';
                    }
                    return ProductSalesMainWidget(
                      name: displayName,
                      price: sale.product.price.toStringAsFixed(2),
                      customer: sale.customer,
                      imageUrl: imageUrl,
                      onTap: () {
                        router.push(
                          '${AppRoutes.salesDetails}?id=${sale.productSaleId}',
                        );
                      },
                    );
                  },
                );
              }
              return const Center(child: Text('No data available'));
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.push(AppRoutes.AddProductSalesScreen);
            },
            backgroundColor: Color(0xff9AE3CE),
            child: Icon(Icons.add, size: 30.sp, color: Colors.black),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}

class ProductSalesSearch extends SearchDelegate {
  ProductSalesSearch(this.allSales);
  final List<dynamic> allSales;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final filtered = allSales.where((sale) {
      final productName = sale.product.name.toLowerCase();
      final customer = sale.customer.toLowerCase();
      final q = query.toLowerCase();
      return productName.contains(q) || customer.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No results',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final sale = filtered[index];
        final displayName = sale.product.name.split(' ').take(3).join(' ');
        String? imageUrl;
        final nameLower = sale.product.name.toLowerCase();
        if (nameLower.contains('medical') || nameLower.contains('syring')) {
          imageUrl =
              'https://static.vecteezy.com/system/resources/previews/060/423/706/non_2x/medical-syringe-with-needle-for-injections-isolated-on-a-clean-transparent-background-representing-healthcare-tools-free-png.png';
        } else if (nameLower.contains('garden') ||
            nameLower.contains('planter')) {
          imageUrl =
              'https://static.vecteezy.com/system/resources/thumbnails/049/668/258/small_2x/wooden-planter-box-with-fresh-herbs-and-greenery-on-a-transparent-background-png.png';
        } else if (nameLower.contains('electronics')) {
          imageUrl =
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPsnX9GwTHCvtz0Jd0gP9TsrNbbZgO_OJA4IRff-HkpqgVO3ICrkWlzxE_HTSw-OuQX2w&usqp=CAU';
        } else if (nameLower.contains('container')) {
          imageUrl =
              'https://www.u-buy.com.ng/productimg/?image=aHR0cHM6Ly9tLm1lZGlhLWFtYXpvbi5jb20vaW1hZ2VzL0kvNzFSbGlSQURlREwuX0FDX1NMMTIwMF8uanBn.jpg';
        } else if (nameLower.contains('pallets')) {
          imageUrl =
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRY2lLtEV4oQJX6R2VUzx9BPrzeR7IDaaZKws6BxeaUur6OksEoodCBJ0Llavk3Q_NCyDw&usqp=CAU';
        } else if (nameLower.contains('cable')) {
          imageUrl =
              'https://images-eu.ssl-images-amazon.com/images/I/61EtcBMUgYL._AC_UL495_SR435,495_.jpg';
        }
        return ProductSalesMainWidget(
          name: displayName,
          price: sale.product.price.toStringAsFixed(2),
          customer: sale.customer,
          imageUrl: imageUrl,
          onTap: () {
            router.push('${AppRoutes.salesDetails}?id=${sale.productSaleId}');
          },
        );
      },
    );
  }
}
