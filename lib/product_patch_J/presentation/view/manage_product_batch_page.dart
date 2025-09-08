// lib/feutaure/product_batch/presentation/pages/manage_product_batch_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/custom_field.dart';

import 'package:tcp212/product_patch_J/presentation/manger/product_batches_cubit.dart';
import 'package:tcp212/product_patch_J/presentation/manger/product_batches_state.dart';
import 'package:tcp212/product_patch_J/repo/product_batches_j_repo.dart';

class ManageProductBatchPage extends StatefulWidget {
  const ManageProductBatchPage({super.key, required this.id});

  final int id;

  @override
  _ManageProductBatchPageState createState() => _ManageProductBatchPageState();
}

class _ManageProductBatchPageState extends State<ManageProductBatchPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  final _reproductionCountController = TextEditingController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = 'ready';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductBatchesJCubit(ProductBatchesJRepoImpl(ApiService())),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'تعديل دفعة إنتاج',
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: BlocConsumer<ProductBatchesJCubit, ProductBatchesJState>(
            listener: (context, state) {
              if (state is ProductBatchesJSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ تم حفظ التعديلات بنجاح!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is ProductBatchesJFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ خطأ: ${state.errorMessage}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final cubit = BlocProvider.of<ProductBatchesJCubit>(context);
              return Center(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 24),
                            CustomTextField(
                              controller: _quantityController,
                              label: const Text('الكمية'),
                              hintText: 'أدخل كمية الإنتاج (مثال: 70)',
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(
                                Icons.production_quantity_limits,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الكمية مطلوبة';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'الرجاء إدخال رقم صحيح';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _notesController,
                              label: const Text('ملاحظات'),
                              hintText: 'ملاحظات حول دفعة الإنتاج)',
                              prefixIcon: const Icon(Icons.notes),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedStatus,
                              decoration: InputDecoration(
                                labelText: 'حالة الإنتاج',
                                hintText: 'اختر حالة الدفعة',
                                prefixIcon: const Icon(
                                  Icons.check_circle_outline,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'ready',
                                  child: Text('✅ جاهز للبيع'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'needs_reproduction',
                                  child: Text('⚠️ يحتاج لإعادة إنتاج'),
                                ),
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            if (_selectedStatus == 'needs_reproduction') ...[
                              CustomTextField(
                                controller: _reproductionCountController,
                                label: const Text('عدد مرات إعادة الإنتاج'),
                                hintText: 'مثال: 1',
                                keyboardType: TextInputType.number,
                                prefixIcon: const Icon(Icons.repeat),
                                validator: (value) {
                                  if (value == null ||
                                      int.tryParse(value) == null) {
                                    return 'الرجاء إدخال عدد صحيح';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            const SizedBox(height: 32),
                            if (state is ProductBatchesJLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      cubit.updateProductBatch(
                                        batchId: widget.id,
                                        quantityIn: int.parse(
                                          _quantityController.text,
                                        ),
                                        notes: _notesController.text,
                                        status: _selectedStatus!,
                                        reproductionCount: int.tryParse(
                                          _reproductionCountController.text,
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.save, color: Colors.white),
                                  label: Text(
                                    'حفظ التعديلات',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade800,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.edit_note, size: 60, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          'تعديل دفعة إنتاج موجودة',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'قم بتغيير البيانات التي تريد تعديلها ثم اضغط حفظ',
          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    _reproductionCountController.dispose();
    super.dispose();
  }
}
