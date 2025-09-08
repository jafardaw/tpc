// // lib/features/products_count/presentation/pages/products_count_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tcp212/feutaure/counts/presentation/manger/products_count_cubit.dart';
// import 'package:tcp212/feutaure/counts/repo/products_count_repository_impl.dart';

// class ProductsCountPage extends StatelessWidget {
//   const ProductsCountPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           'Product Statistics',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue[700],
//         elevation: 4,
//         shadowColor: Colors.blue.withOpacity(0.3),
//       ),
//       body: BlocProvider(
//         create: (context) => ProductsCountCubit(
//           repository: context.read<ProductsCountRepositoryImpl>(),
//         )..fetchProductsCount(),
//         child: const ProductsCountView(),
//       ),
//     );
//   }
// }

// class ProductsCountView extends StatelessWidget {
//   const ProductsCountView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductsCountCubit, ProductsCountState>(
//       builder: (context, state) {
//         if (state is ProductsCountLoading) {
//           return _buildLoadingState();
//         } else if (state is ProductsCountLoaded) {
//           return _buildLoadedState(context, state.count);
//         } else if (state is ProductsCountError) {
//           return _buildErrorState(context, state.message);
//         } else {
//           return _buildInitialState();
//         }
//       },
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
//             strokeWidth: 4,
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Loading product statistics...',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadedState(BuildContext context, String count) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Animated Counter
//           _buildAnimatedCounter(count),
//           const SizedBox(height: 30),
//           // Info Card
//           _buildInfoCard(context),
//           const SizedBox(height: 30),
//           // Refresh Button
//           _buildRefreshButton(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildAnimatedCounter(String count) {
//     return TweenAnimationBuilder(
//       duration: const Duration(seconds: 2),
//       builder: (context, value, child) {
//         return Container(
//           padding: const EdgeInsets.all(30),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.blue.withOpacity(0.2),
//                 blurRadius: 15,
//                 spreadRadius: 3,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Text(
//             '$value',
//             style: TextStyle(
//               fontSize: 48,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[700],
//               shadows: [
//                 Shadow(
//                   blurRadius: 10,
//                   color: Colors.blue.withOpacity(0.3),
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInfoCard(BuildContext context) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       shadowColor: Colors.blue.withOpacity(0.2),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Icon(
//               Icons.inventory_2,
//               size: 50,
//               color: Colors.blue[700],
//             ),
//             const SizedBox(height: 15),
//             Text(
//               'Total Products in System',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[800],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'This represents all products currently available in your inventory management system.',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//                 height: 1.4,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRefreshButton(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: () {
//         context.read<ProductsCountCubit>().fetchProductsCount();
//       },
//       icon: const Icon(Icons.refresh),
//       label: const Text('Refresh Data'),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 4,
//       ),
//     );
//   }

//   Widget _buildErrorState(BuildContext context, String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 60,
//               color: Colors.red[400],
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Oops! Something went wrong',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//             const SizedBox(height: 15),
//             Text(
//               message,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton.icon(
//               onPressed: () {
//                 context.read<ProductsCountCubit>().fetchProductsCount();
//               },
//               icon: const Icon(Icons.refresh),
//               label: const Text('Try Again'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue[700],
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInitialState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inventory,
//             size: 60,
//             color: Colors.blue[300],
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Ready to load product statistics',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
