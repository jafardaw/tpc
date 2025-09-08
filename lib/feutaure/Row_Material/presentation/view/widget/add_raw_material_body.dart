import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/custom_field.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/feutaure/Row_Material/data/add_raw_material_model.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_add/add_raw_material_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_add/add_raw_material_state.dart';

class AddRawMaterialBody extends StatefulWidget {
  const AddRawMaterialBody({super.key});

  @override
  State<AddRawMaterialBody> createState() => _AddRawMaterialBodyState();
}

class _AddRawMaterialBodyState extends State<AddRawMaterialBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _minStockAlertController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _statusController.dispose();
    _minStockAlertController.dispose();
    super.dispose();
  }

  void _addRawMaterial() {
    if (_formKey.currentState!.validate()) {
      final rawMaterial = RawMaterial(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        status: _statusController.text,
        minimumStockAlert: int.tryParse(_minStockAlertController.text) ?? 0,
      );
      context.read<AddRawMaterialCubit>().addRawMaterial(rawMaterial);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Palette.primary : Palette.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'إضافة مادة خام جديدة',
        ),
      ),
      body: BlocConsumer<AddRawMaterialCubit, AddRawMaterialState>(
        listener: (context, state) {
          if (state is AddRawMaterialSuccess) {
            _showSnackBar(state.message, isError: false);
            _nameController.clear();
            _descriptionController.clear();
            _priceController.clear();
            _statusController.clear();
            _minStockAlertController.clear();
          } else if (state is AddRawMaterialError) {
            _showSnackBar(state.message, isError: true);
          }
        },
        builder: (context, state) {
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
                  ElevatedButton(
                    onPressed: state is AddRawMaterialLoading
                        ? null
                        : _addRawMaterial,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                    ),
                    child: state is AddRawMaterialLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'إضافة المادة الخام',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
