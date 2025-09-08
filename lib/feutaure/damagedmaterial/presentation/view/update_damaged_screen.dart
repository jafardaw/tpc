import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/custom_field.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/manger/cubit/cubit/create_damaged_material_cubit.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/manger/cubit/cubit/create_damaged_material_state.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/manger/cubit/cubit/update_damged_cubit.dart';
import 'package:tcp212/feutaure/damagedmaterial/repo/damaged_material_repository_imp.dart';

class UpdateDamagedMaterialScreen extends StatefulWidget {
  final int rawMaterialBatchIdOrProductBatchId;
  const UpdateDamagedMaterialScreen({
    super.key,
    required this.rawMaterialBatchIdOrProductBatchId,
  });

  @override
  State<UpdateDamagedMaterialScreen> createState() =>
      _UpdateDamagedMaterialScreenState();
}

class _UpdateDamagedMaterialScreenState
    extends State<UpdateDamagedMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _rawMaterialBatchIdController;
  late TextEditingController _productBatchIdController;

  @override
  void dispose() {
    _quantityController.dispose();
    _rawMaterialBatchIdController.dispose();
    _productBatchIdController.dispose();
    super.dispose();
  }

  void _createDamagedMaterial() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      context.read<UpdateDamgedCubit>().updateDamagedMaterial(
        1,
        // productBatchId: productBatchId,
        quantity: double.parse(_quantityController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateDamagedMaterialCubit(
        DamagedMaterialRepositoryImp(ApiService()),
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'تسجيل مادة تالفة جديدة',
          ),
        ),
        body:
            BlocListener<
              CreateDamagedMaterialCubit,
              CreateDamagedMaterialState
            >(
              listener: (context, state) {
                if (state is CreateDamagedMaterialSuccess) {
                  showCustomSnackBar(
                    context,
                    state.message,
                    color: Palette.primarySuccess,
                  );

                  // Optionally pop back to the previous screen or clear form
                  Navigator.of(context).pop();
                } else if (state is CreateDamagedMaterialError) {
                  showCustomSnackBar(
                    context,
                    state.message,
                    color: Palette.primaryError,
                  );
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.new_releases, // Icon for new entry
                          color: Colors.orange[700],
                          size: 80,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Icons.numbers),
                          labelText: 'الكمية التالفة',
                          hintText: 'أدخل الكمية التي تلفت',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الكمية التالفة.';
                            }
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0) {
                              return 'الرجاء إدخال رقم موجب صحيح للكمية.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<
                          CreateDamagedMaterialCubit,
                          CreateDamagedMaterialState
                        >(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: state is CreateDamagedMaterialLoading
                                    ? null
                                    : _createDamagedMaterial,
                                icon: state is CreateDamagedMaterialLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Icon(Icons.save),
                                label: Text(
                                  state is CreateDamagedMaterialLoading
                                      ? 'جاري الحفظ...'
                                      : 'تسجيل مادة تالفة',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
