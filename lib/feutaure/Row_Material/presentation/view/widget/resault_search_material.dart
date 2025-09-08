import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_state.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/widget/card_raw_material.dart';

class RawMaterialResultsSection extends StatelessWidget {
  const RawMaterialResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RawMaterialSearchCubit, RawMaterialSearchState>(
      builder: (context, state) {
        if (state is RawMaterialSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2.0),
          );
        } else if (state is RawMaterialSearchError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    // يمكنك استدعاء دالة البحث هنا مرة أخرى
                    // بما أن الـ cubit موجود في الشجرة، يمكننا الوصول إليه
                    context.read<RawMaterialSearchCubit>().searchRawMaterials();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        } else if (state is RawMaterialSearchSuccess) {
          if (state.results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد نتائج',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'حاول تغيير معايير البحث',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final rawMaterial = state.results[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CardShapeRawmaterial(rawMaterial: rawMaterial),
              );
            },
          );
        }
        // الحالة الأولية أو عندما لا تكون هناك نتائج بحث بعد
        return Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'استخدم فلاتر البحث للبدء',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// class RawMaterialResultsSection extends StatelessWidget {
//   const RawMaterialResultsSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RawMaterialSearchCubit, RawMaterialSearchState>(
//       builder: (context, state) {
//         // الحالة الأولية أو عندما لا تكون هناك نتائج بحث بعد
//         Widget buildEmptyState(String message,
//             {String? subMessage, IconData icon = Icons.search}) {
//           return SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: Container(
//               constraints: BoxConstraints(
//                 minHeight: MediaQuery.of(context).size.height * 0.6,
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(icon, size: 48, color: Colors.grey),
//                     const SizedBox(height: 16),
//                     Text(
//                       message,
//                       style: Theme.of(context).textTheme.titleMedium,
//                       textAlign: TextAlign.center,
//                     ),
//                     if (subMessage != null) ...[
//                       const SizedBox(height: 8),
//                       Text(
//                         subMessage,
//                         style: Theme.of(context).textTheme.bodyMedium,
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }

//         if (state is RawMaterialSearchLoading) {
//           return const Center(child: CircularProgressIndicator(                  strokeWidth: 2.0,

//         } else if (state is RawMaterialSearchError) {
//           return buildEmptyState(
//             state.message,
//             icon: Icons.error_outline,
//             subMessage: 'حاول مرة أخرى',
//           );
//         } else if (state is RawMaterialSearchSuccess) {
//           if (state.results.isEmpty) {
//             return buildEmptyState(
//               'لا توجد نتائج',
//               subMessage: 'حاول تغيير معايير البحث',
//               icon: Icons.search_off,
//             );
//           }
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: state.results.length,
//             itemBuilder: (context, index) {
//               final rawMaterial = state.results[index];
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: CardShapeRawmaterial(
//                   rawMaterial: rawMaterial,
//                 ),
//               );
//             },
//           );
//         }

//         return buildEmptyState('استخدم فلاتر البحث للبدء');
//       },
//     );
//   }
// }
