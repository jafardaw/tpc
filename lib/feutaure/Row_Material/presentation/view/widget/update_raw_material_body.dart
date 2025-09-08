import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/widget/custom_field.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_state.dart';

class UpdateRawmaterialBody extends StatelessWidget {
  const UpdateRawmaterialBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required TextEditingController priceController,
    required TextEditingController statusController,
    required TextEditingController minStockAlertController,
    required this.onUpdatePressed,
  }) : _formKey = formKey,
       _nameController = nameController,
       _descriptionController = descriptionController,
       _priceController = priceController,
       _statusController = statusController,
       _minStockAlertController = minStockAlertController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _nameController;
  final TextEditingController _descriptionController;
  final TextEditingController _priceController;
  final TextEditingController _statusController;
  final TextEditingController _minStockAlertController;
  final VoidCallback onUpdatePressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _nameController,
              labelText: 'اسم المادة الخام',
              hintText: 'أدخل اسم المادة الخام',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم المادة الخام';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              labelText: 'الوصف',
              hintText: 'أدخل وصف المادة الخام',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال وصف المادة الخام';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _priceController,
              labelText: 'السعر',
              hintText: 'أدخل سعر المادة الخام',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال السعر';
                }
                if (double.tryParse(value) == null) {
                  return 'الرجاء إدخال سعر صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _statusController,
              labelText: 'الحالة',
              hintText: 'أدخل حالة المادة الخام (مثال: used, new)',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال حالة المادة الخام';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _minStockAlertController,
              labelText: 'الحد الأدنى للتنبيه',
              hintText: 'أدخل الحد الأدنى للتنبيه عند نقص المخزون',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال الحد الأدنى للتنبيه';
                }
                if (int.tryParse(value) == null) {
                  return 'الرجاء إدخال رقم صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            BlocBuilder<UpdateRawMaterialCubit, UpdateRawmaterialState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is UpdateRawMaterialLoading
                      ? null
                      : onUpdatePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                  ),
                  child: state is UpdateRawMaterialLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'تحديث المادة الخام',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
