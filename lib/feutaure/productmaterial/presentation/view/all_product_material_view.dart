import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/productmaterial/data/product_material_model.dart';
import 'package:tcp212/feutaure/productmaterial/repo/repo_product_material.dart';

abstract class ProductMaterialsState {}

class ProductMaterialsInitial extends ProductMaterialsState {}

class ProductMaterialsLoading extends ProductMaterialsState {}

class ProductMaterialsLoaded extends ProductMaterialsState {
  final List<ProductMaterialRelationship> relationships;
  ProductMaterialsLoaded({required this.relationships});
}

class ProductMaterialsError extends ProductMaterialsState {
  final String errorMessage;
  ProductMaterialsError({required this.errorMessage});
}

// يمكن إضافة حالة لنجاح عملية (مثل الحذف أو التعديل) إذا لزم الأمر
// class ProductMaterialsActionSuccess extends ProductMaterialsState {
//   final String message;
//   // قد ترغب في الاحتفاظ بقائمة العلاقات بعد النجاح
//   final List<ProductMaterialRelationship> relationships;
//   ProductMaterialsActionSuccess(
//       {required this.message, required this.relationships});
// }

// lib/feutaure/product_materials/repo/product_materials_repo.dart

class ProductMaterialsCubit extends Cubit<ProductMaterialsState> {
  final ProductMaterialsRepo _repository;

  ProductMaterialsCubit(this._repository) : super(ProductMaterialsInitial());

  Future<void> fetchProductMaterials() async {
    emit(ProductMaterialsLoading());
    try {
      final relationships = await _repository.fetchProductMaterials();
      emit(ProductMaterialsLoaded(relationships: relationships));
    } catch (e) {
      emit(ProductMaterialsError(errorMessage: e.toString()));
    }
  }
}

////////////////////////////////////////
///
///
///

// امتداد لـ String لجعل أول حرف من كل كلمة كبيرًا
extension StringExtension on String {
  String capitalizeFirstofEach() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}

class ProductMaterialsListView extends StatefulWidget {
  const ProductMaterialsListView({super.key});

  @override
  State<ProductMaterialsListView> createState() =>
      _ProductMaterialsListViewState();
}

class _ProductMaterialsListViewState extends State<ProductMaterialsListView> {
  @override
  void initState() {
    super.initState();
    // عند تهيئة الشاشة، اطلب من الـ Cubit جلب البيانات
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ProductMaterialsCubit>().fetchProductMaterials(); // });
  }

  // دالة مساعدة لإنشاء صف معلومات بليبل وقيمة مع أيقونة
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
    return Scaffold(
      backgroundColor: Colors.grey[100], // خلفية فاتحة وبسيطة
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Product Components', // عنوان جديد
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProductMaterialsCubit>().fetchProductMaterials();
        },
        color: Colors.indigo,
        child: BlocConsumer<ProductMaterialsCubit, ProductMaterialsState>(
          listener: (context, state) {
            if (state is ProductMaterialsError) {
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
            if (state is ProductMaterialsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.indigo),
              );
            } else if (state is ProductMaterialsLoaded) {
              if (state.relationships.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.link_off, size: 100, color: Colors.grey[400]),
                      const SizedBox(height: 20),
                      Text(
                        'No product material relationships to display.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<ProductMaterialsCubit>()
                              .fetchProductMaterials();
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
                itemCount: state.relationships.length,
                itemBuilder: (context, index) {
                  final relationship = state.relationships[index];
                  // تحديد نوع المكون للعرض
                  final String componentName =
                      relationship.componentType == 'raw_material'
                      ? relationship.rawMaterial?.name ?? 'N/A'
                      : relationship.semiProduct?.name ?? 'N/A';
                  final String componentTypeDisplay = relationship.componentType
                      .replaceAll('_', ' ')
                      .capitalizeFirstofEach();

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
                          // عنوان المنتج الرئيسي
                          Text(
                            'Product: ${relationship.product!.name}',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          _buildInfoRow(
                            'Product ID',
                            '${relationship.product!.productId}',
                            icon: Icons.qr_code,
                            iconColor: Colors.grey[600],
                          ),
                          _buildInfoRow(
                            'Product Category',
                            relationship.product!.category,
                            icon: Icons.category,
                            iconColor: Colors.deepPurple,
                          ),

                          const SizedBox(height: 15),
                          const Divider(
                            height: 1,
                            thickness: 0.8,
                            color: Colors.indigo,
                          ),
                          const SizedBox(height: 15),

                          // تفاصيل المكون (مادة خام أو شبه منتج)
                          Text(
                            'Component: $componentName ($componentTypeDisplay)',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          _buildInfoRow(
                            'Required Quantity',
                            '${relationship.quantityRequiredPerUnit}',
                            icon: Icons.production_quantity_limits,
                            iconColor: Colors.orange[700],
                          ),

                          // عرض تفاصيل المادة الخام أو شبه المنتج بناءً على النوع
                          if (relationship.componentType == 'raw_material' &&
                              relationship.rawMaterial != null) ...[
                            _buildInfoRow(
                              'Raw Material ID',
                              '${relationship.rawMaterial!.rawMaterialId}',
                              icon: Icons.straighten,
                              iconColor: Colors.grey[600],
                            ),
                            _buildInfoRow(
                              'Raw Material Price',
                              '${relationship.rawMaterial!.price} SAR',
                              icon: Icons.monetization_on,
                              iconColor: Colors.green[700],
                            ),
                            _buildInfoRow(
                              'Raw Material Status',
                              relationship.rawMaterial!.status,
                              icon: Icons.info_outline,
                              iconColor: Colors.teal,
                            ),
                          ] else if (relationship.componentType ==
                                  'semi_product' &&
                              relationship.semiProduct != null) ...[
                            _buildInfoRow(
                              'Semi-Product ID',
                              '${relationship.semiProduct!.productId}',
                              icon: Icons.precision_manufacturing,
                              iconColor: Colors.grey[600],
                            ),
                            _buildInfoRow(
                              'Semi-Product Price',
                              '${relationship.semiProduct!.price} SAR',
                              icon: Icons.monetization_on,
                              iconColor: Colors.green[700],
                            ),
                            _buildInfoRow(
                              'Semi-Product Category',
                              relationship.semiProduct!.category,
                              icon: Icons.category,
                              iconColor: Colors.purple,
                            ),
                          ],

                          const SizedBox(height: 15),
                          const Divider(
                            height: 1,
                            thickness: 0.8,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),

                          // تواريخ الإنشاء والتحديث
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Created: ${DateFormat('yyyy-MM-dd HH:mm').format(relationship.createdAt.toLocal())}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Updated: ${DateFormat('yyyy-MM-dd HH:mm').format(relationship.updatedAt.toLocal())}',
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

                          // أزرار الإجراءات: تعديل وحذف
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                                tooltip: 'Edit Component',
                                onPressed: () {},
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 24,
                                ),
                                tooltip: 'Delete Component',
                                onPressed: () {
                                  _confirmDeleteProductMaterial(
                                    context,
                                    relationship,
                                  );
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
              // حالة افتراضية (قد تكون ProductMaterialsInitial أو حالة غير متوقعة)
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
                      'Tap refresh to load product components.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<ProductMaterialsCubit>()
                            .fetchProductMaterials();
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
    );
  }

  // دالة مساعدة لتأكيد الحذف
  void _confirmDeleteProductMaterial(
    BuildContext context,
    ProductMaterialRelationship relationship,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete this component relationship for "${relationship.product!.name}"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // إغلاق مربع الحوار
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // إغلاق مربع الحوار
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
