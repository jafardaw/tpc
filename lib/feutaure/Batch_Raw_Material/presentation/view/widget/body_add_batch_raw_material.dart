import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // استيراد Bloc
import 'package:tcp212/core/widget/custom_button.dart';
import 'package:tcp212/core/widget/custom_field.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_state.dart';

// تحويل Widget إلى StatefulWidget لإدارة حالة حقول الإدخال ومفتاح النموذج
class BodyAddBatchRawMaterial extends StatefulWidget {
  const BodyAddBatchRawMaterial({super.key, this.rawid});
  final rawid;
  @override
  State<BodyAddBatchRawMaterial> createState() =>
      _BodyAddBatchRawMaterialState();
}

class _BodyAddBatchRawMaterialState extends State<BodyAddBatchRawMaterial> {
  // مفتاح النموذج للتحقق من صحة المدخلات
  final _formKey = GlobalKey<FormState>();

  // متحكمات حقول الإدخال للبيانات الجديدة الخاصة بالدفعة
  final TextEditingController _rawMaterialIdController =
      TextEditingController();
  final TextEditingController _quantityInController = TextEditingController();
  final TextEditingController _realCostController = TextEditingController();
  final TextEditingController _paymentMethodController =
      TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    // التخلص من المتحكمات لمنع تسرب الذاكرة
    _rawMaterialIdController.dispose();
    _quantityInController.dispose();
    _realCostController.dispose();
    _paymentMethodController.dispose();
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // دالة لمعالجة إضافة الدفعة عند النقر على الزر
  void _addBatch() {
    // التحقق من صحة جميع حقول النموذج
    if (_formKey.currentState!.validate()) {
      // النموذج صالح، قم بجمع البيانات
      final int quantityIn = int.parse(_quantityInController.text);
      final double realCost = double.parse(_realCostController.text);
      final String paymentMethod = _paymentMethodController.text;
      final String supplier = _supplierController.text;
      final String notes = _notesController.text;

      // إنشاء خريطة بالبيانات لإرسالها إلى الـ Cubit
      final Map<String, dynamic> batchData = {
        'raw_material_id': widget.rawid,
        'quantity_in': quantityIn,
        'real_cost': realCost,
        'payment_method': paymentMethod,
        'supplier': supplier,
        'notes': notes,
      };

      context.read<AddRawMaterialBatchCubit>().addRawMaterialBatch(batchData);
      print('batchDatammmmmmmmmmmmmmmmmmmmmmmmmm$batchData');
    }
  }

  // دالة لمسح جميع حقول الإدخال
  void _clearFields() {
    _rawMaterialIdController.clear();
    _quantityInController.clear();
    _realCostController.clear();
    _paymentMethodController.clear();
    _supplierController.clear();
    _notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام BlocConsumer للاستماع إلى الحالات وإعادة بناء الواجهة
      body: BlocConsumer<AddRawMaterialBatchCubit, AddRawMaterialBatchState>(
        listener: (context, state) {
          // الاستماع إلى حالات الـ Cubit وعرض رسائل للمستخدم
          if (state is AddRawMaterialBatchSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // مسح الحقول بعد الإضافة الناجحة
            _clearFields();
          } else if (state is AddRawMaterialBatchError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0), // مسافة بادئة حول النموذج
            child: Form(
              key: _formKey, // ربط مفتاح النموذج
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // تمديد العناصر عرضياً
                children: [
                  // حقل معرف المادة الخام (لربط الدفعة بمادة خام موجودة)
                  CustomTextField(
                    controller: _rawMaterialIdController,
                    labelText: 'معرف المادة الخام',
                    hintText: 'أدخل معرف المادة الخام المراد إضافة دفعة لها',
                    keyboardType: TextInputType.number, // لوحة مفاتيح رقمية
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال معرف المادة الخام';
                      }
                      if (int.tryParse(value) == null) {
                        return 'الرجاء إدخال رقم صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16), // مسافة فاصلة
                  // حقل الكمية الداخلة
                  CustomTextField(
                    controller: _quantityInController,
                    labelText: 'الكمية الداخلة',
                    hintText: 'أدخل الكمية التي تم شراؤها',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الكمية الداخلة';
                      }
                      if (int.tryParse(value) == null) {
                        return 'الرجاء إدخال رقم صحيح للكمية';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل التكلفة الفعلية
                  CustomTextField(
                    controller: _realCostController,
                    labelText: 'التكلفة الفعلية',
                    hintText: 'أدخل التكلفة الفعلية للدفعة',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال التكلفة الفعلية';
                      }
                      if (double.tryParse(value) == null) {
                        return 'الرجاء إدخال قيمة رقمية صحيحة للتكلفة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل طريقة الدفع
                  CustomTextField(
                    controller: _paymentMethodController,
                    labelText: 'طريقة الدفع',
                    hintText: 'أدخل طريقة الدفع (مثال: نقداً، تحويل بنكي)',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال طريقة الدفع';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل المورد
                  CustomTextField(
                    controller: _supplierController,
                    labelText: 'المورد',
                    hintText: 'أدخل اسم المورد',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم المورد';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل الملاحظات (اختياري)
                  CustomTextField(
                    controller: _notesController,
                    labelText: 'ملاحظات',
                    hintText: 'أدخل أي ملاحظات إضافية',
                    maxLines: 3, // السماح بعدة أسطر للملاحظات
                    validator: (value) {
                      // الملاحظات عادة ما تكون اختيارية، لذا لا يوجد validator إلزامي هنا
                      return null;
                    },
                  ),
                  const SizedBox(height: 32), // مسافة أكبر قبل الزر
                  // زر إضافة الدفعة
                  CustomButton(
                    onTap: state is AddRawMaterialBatchLoading
                        ? null
                        : _addBatch,
                    text: state is AddRawMaterialBatchLoading
                        ? 'جاري الإضافة...'
                        : 'إضافة دفعة المادة الخام',
                  ),
                  // عرض مؤشر تحميل دائري إذا كانت الحالة RawMaterialBatchLoading
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
