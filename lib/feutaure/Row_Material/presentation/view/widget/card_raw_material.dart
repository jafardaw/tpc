import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/add_batch_raw_material_view.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/widget/get_all_batch_for_rowmaterial_id.dart';
import 'package:tcp212/feutaure/Row_Material/data/get_raw_material_model.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_state.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/update_raw_material_view.dart';

class CardShapeRawmaterial extends StatelessWidget {
  const CardShapeRawmaterial({super.key, required this.rawMaterial});

  final GetRawMaterialModel rawMaterial;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  rawMaterial.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.teal.shade600, size: 22),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBatchRawMaterialView(
                          rawid: rawMaterial.rawMaterialId,
                        ),
                      ),
                    );
                  },
                  tooltip: 'add batch',
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.teal.shade600, size: 22),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateRawMaterialView(rowmaterial: rawMaterial),
                      ),
                    );
                  },
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade600,
                    size: 22,
                  ),
                  onPressed: () {
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
                          BlocConsumer<
                            UpdateRawMaterialCubit,
                            UpdateRawmaterialState
                          >(
                            listener: (context, state) {
                              if (state is DeleatRawMaterialSuccess) {
                                Navigator.pop(
                                  context,
                                ); // إغلاق dialog عند النجاح
                              }
                            },
                            builder: (context, state) {
                              return TextButton(
                                onPressed: state is DeleatRawMaterialLoading
                                    ? null
                                    : () {
                                        context
                                            .read<UpdateRawMaterialCubit>()
                                            .deleatRawMaterial(
                                              rawMaterial.rawMaterialId,
                                            );
                                      },
                                child: state is DeleatRawMaterialLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        'حذف',
                                        style: TextStyle(color: Colors.red),
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300, thickness: 1),
            Text(
              rawMaterial.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price: \$${rawMaterial.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                Chip(
                  label: Text(
                    rawMaterial.status == 'used' ? 'Used' : 'Unused',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: rawMaterial.status == 'used'
                          ? Colors.white
                          : Colors.grey.shade800,
                    ),
                  ),
                  backgroundColor: rawMaterial.status == 'used'
                      ? Colors.teal.shade600
                      : Colors.amber.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Minimum stock alert: ${rawMaterial.minimumStockAlert}',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Created at: ${rawMaterial.createdAt.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetAllBatchForRowmaterialId(
                          rawMaterialId: rawMaterial.rawMaterialId,
                          namerawmaterial: rawMaterial.name,
                          rawMaterialPrice: rawMaterial.price,
                          rawMaterialStatus: rawMaterial.status,
                          rawMaterialDescription: rawMaterial.description,
                          minimumStockAlert: rawMaterial.minimumStockAlert,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.batch_prediction, color: Colors.blue),
                  tooltip: 'batchs',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
