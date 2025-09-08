import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_state.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/widget/card_raw_material.dart';

class RawMaterialsListBody extends StatefulWidget {
  const RawMaterialsListBody({super.key});

  @override
  State<RawMaterialsListBody> createState() => _RawMaterialsListBodyState();
}

class _RawMaterialsListBodyState extends State<RawMaterialsListBody> {
  String _currentFilter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<GetRawMaterialsCubit>().fetchRawMaterials();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.teal.shade600,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          _buildFilterChip('All', _currentFilter == 'All'),
          _buildFilterChip('Used', _currentFilter == 'Used'),
          _buildFilterChip('Unused', _currentFilter == 'Unused'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _currentFilter = selected ? label : 'All';
        });
        context.read<GetRawMaterialsCubit>().filterRawMaterials(_currentFilter);
      },
      selectedColor: Colors.teal.shade100,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.teal.shade800 : Colors.grey.shade800,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.teal.shade600 : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      checkmarkColor: Colors.teal.shade800,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: BlocConsumer<GetRawMaterialsCubit, GetRawMaterialsState>(
            listener: (context, state) {
              if (state is GetRawMaterialsError) {
                _showSnackBar(state.message, isError: true);
              }
            },
            builder: (context, state) {
              if (state is GetRawMaterialsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                );
              } else if (state is GetRawMaterialsSuccess) {
                if (state.rawMaterials.isEmpty) {
                  return Center(
                    child: Text(
                      'No raw materials available.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: state.rawMaterials.length,
                  itemBuilder: (context, index) {
                    final rawMaterial = state.rawMaterials[index];
                    return CardShapeRawmaterial(rawMaterial: rawMaterial);
                  },
                );
              } else if (state is GetRawMaterialsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.teal.shade600,
                        size: 50,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Failed to load data: ${state.message}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal.shade800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<GetRawMaterialsCubit>()
                              .fetchRawMaterials();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: Text(
                  'Start fetching raw materials.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// class CardShapeRawmaterial extends StatelessWidget {
//   const CardShapeRawmaterial({
//     super.key,
//     required this.rawMaterial,
//   });

//   final GetRawMaterialModel rawMaterial;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(
//           color: Colors.grey.shade200,
//           width: 1,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   rawMaterial.name,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.teal.shade800,
//                   ),
//                 ),
//                 const Spacer(),
//                 // IconButton(
//                 //   icon: Icon(Icons.edit, color: Colors.teal.shade600, size: 22),
//                 //   onPressed: () async {
//                 //     final result = await Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //         builder: (context) => BlocProvider(
//                 //           create: (context) => UpdateRawMaterialCubit(
//                 //               rawMaterialRepository: RawMaterialRepository(
//                 //                   apiService: ApiService())),
//                 //           child: UpdateRawMaterialView(
//                 //             rowmaterial: rawMaterial,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     );

//                 //     if (result == true) {
//                 //       // أعد تحميل البيانات هنا
//                 //       // مثلاً إذا كنت تستخدم Bloc:
//                 //       context.read<GetRawMaterialsCubit>().fetchRawMaterials();
//                 //     }
//                 //   },
//                 //   tooltip: 'Edit',
//                 // ),
//                 IconButton(
//                   icon: Icon(Icons.edit, color: Colors.teal.shade600, size: 22),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => UpdateRawMaterialView(
//                                 rowmaterial: rawMaterial,
//                               )),
//                     );
//                   },
//                   tooltip: 'Edit',
//                 ),
//                 // IconButton(
//                 //   icon:
//                 //       Icon(Icons.delete, color: Colors.red.shade600, size: 22),
//                 //   onPressed: () {
//                 //     context
//                 //         .read<UpdateRawMaterialCubit>()
//                 //         .deleatRawMaterial(rawMaterial.rawMaterialId);
//                 //   },
//                 //   tooltip: 'Delete',
//                 // ),

//                 IconButton(
//                   icon:
//                       Icon(Icons.delete, color: Colors.red.shade600, size: 22),
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: const Text('تأكيد الحذف'),
//                         content: const Text(
//                             'هل أنت متأكد من رغبتك في حذف هذه المادة؟'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('إلغاء'),
//                           ),
//                           BlocConsumer<UpdateRawMaterialCubit,
//                               UpdateRawmaterialState>(
//                             listener: (context, state) {
//                               if (state is DeleatRawMaterialSuccess) {
//                                 Navigator.pop(
//                                     context); // إغلاق dialog عند النجاح
//                               }
//                             },
//                             builder: (context, state) {
//                               return TextButton(
//                                 onPressed: state is DeleatRawMaterialLoading
//                                     ? null
//                                     : () {
//                                         context
//                                             .read<UpdateRawMaterialCubit>()
//                                             .deleatRawMaterial(
//                                                 rawMaterial.rawMaterialId);
//                                       },
//                                 child: state is DeleatRawMaterialLoading
//                                     ? const CircularProgressIndicator()
//                                     : const Text('حذف',
//                                         style: TextStyle(color: Colors.red)),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 )
//               ],
//             ),
//             const SizedBox(height: 8),
//             Divider(
//               color: Colors.grey.shade300,
//               thickness: 1,
//             ),
//             Text(
//               rawMaterial.description,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Price: \$${rawMaterial.price.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey.shade800,
//                   ),
//                 ),
//                 Chip(
//                   label: Text(
//                     rawMaterial.status == 'used' ? 'Used' : 'Unused',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                       color: rawMaterial.status == 'used'
//                           ? Colors.white
//                           : Colors.grey.shade800,
//                     ),
//                   ),
//                   backgroundColor: rawMaterial.status == 'used'
//                       ? Colors.teal.shade600
//                       : Colors.amber.shade100,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Minimum stock alert: ${rawMaterial.minimumStockAlert}',
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.grey.shade800,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Created at: ${rawMaterial.createdAt.toLocal().toString().split(' ')[0]}',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
