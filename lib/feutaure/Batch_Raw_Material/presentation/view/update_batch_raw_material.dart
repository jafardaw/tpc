import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/custom_button.dart';
import 'package:tcp212/core/widget/custom_field.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/data/batch_raw_material_model.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_state.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart';

class UpdateBatchRawMaterial extends StatelessWidget {
  const UpdateBatchRawMaterial({
    super.key,
    required this.rawMaterialBatchModel,
  });

  final RawMaterialBatchModel rawMaterialBatchModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Update Raw Material Batch',
        ),
      ),
      body: UpdateBatchRawMaterialBody(
        rawMaterialBatchModel: rawMaterialBatchModel,
      ),
    );
  }
}

class UpdateBatchRawMaterialBody extends StatefulWidget {
  const UpdateBatchRawMaterialBody({
    super.key,
    required this.rawMaterialBatchModel,
  });
  final RawMaterialBatchModel rawMaterialBatchModel;
  @override
  State<UpdateBatchRawMaterialBody> createState() =>
      _UpdateBatchRawMaterialBodyState();
}

class _UpdateBatchRawMaterialBodyState
    extends State<UpdateBatchRawMaterialBody> {
  late final TextEditingController _quantityInController;
  late final TextEditingController _realCostController;
  late final TextEditingController _paymentMethodController;
  late final TextEditingController _supplierController;
  late final TextEditingController _notesController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with model values
    _quantityInController = TextEditingController(
      text: widget.rawMaterialBatchModel.quantityIn.toString(),
    );
    _realCostController = TextEditingController(
      text: widget.rawMaterialBatchModel.realCost.toString(),
    );
    _paymentMethodController = TextEditingController(
      text: widget.rawMaterialBatchModel.paymentMethod,
    );
    _supplierController = TextEditingController(
      text: widget.rawMaterialBatchModel.supplier,
    );
    _notesController = TextEditingController(
      text: widget.rawMaterialBatchModel.notes,
    );
  }

  @override
  void dispose() {
    _quantityInController.dispose();
    _realCostController.dispose();
    _paymentMethodController.dispose();
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateRawMaterial() {
    // Validate all form fields
    if (_formKey.currentState!.validate()) {
      // Form is valid, collect the data
      final double quantityIn = double.parse(_quantityInController.text);
      final double realCost = double.parse(_realCostController.text);
      final String paymentMethod = _paymentMethodController.text;
      final String supplier = _supplierController.text;
      final String notes = _notesController.text;

      // Create a map with the data to send to the Cubit
      final Map<String, dynamic> batchData = {
        "quantity_in": quantityIn,
        'real_cost': realCost,
        'payment_method': paymentMethod,
        'supplier': supplier,
        'notes': notes,
      };

      // Call the Cubit to update the raw material batch
      context.read<UpdateBatchRawMaterialCubit>().updateRawMaterialBatch(
        widget.rawMaterialBatchModel.rawMaterialBatchId,
        batchData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      UpdateBatchRawMaterialCubit,
      UpdateBatchRawMaterialState
    >(
      listener: (context, state) {
        if (state is UpdateBatchRawMaterialLoading) {
          // Show a loading indicator (e.g., CircularProgressIndicator in a dialog)
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Updating batch...')));
        } else if (state is UpdateBatchRawMaterialSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // You might want to pop the screen or refresh the previous list here
          // Navigator.pop(context, true); // Pass true to indicate a successful update
        } else if (state is UpdateBatchRawMaterialError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Quantity In Field
              CustomTextField(
                controller: _quantityInController,
                label: const Text('Quantity In'),
                hintText: 'Enter quantity',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Quantity must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Real Cost Field
              CustomTextField(
                controller: _realCostController,
                label: const Text('Real Cost'),
                hintText: 'Enter cost',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Cost must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Payment Method Field
              CustomTextField(
                controller: _paymentMethodController,
                label: const Text('Payment Method'),
                hintText: 'Enter payment method (cash, credit, etc.)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter payment method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Supplier Field
              CustomTextField(
                controller: _supplierController,
                label: const Text('Supplier'),
                hintText: 'Enter supplier name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter supplier';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Notes Field (Optional)
              CustomTextField(
                controller: _notesController,
                label: const Text('Notes (Optional)'),
                hintText: 'Enter any notes',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Update Button
              BlocBuilder<
                UpdateBatchRawMaterialCubit,
                UpdateBatchRawMaterialState
              >(
                builder: (context, state) {
                  return CustomButton(
                    text: state is UpdateBatchRawMaterialLoading
                        ? 'Updating...'
                        : 'Update',
                    onTap: state is UpdateBatchRawMaterialLoading
                        ? null
                        : _updateRawMaterial,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateBatchRawMaterial2 extends StatelessWidget {
  const UpdateBatchRawMaterial2({
    super.key,
    required this.rawMaterialBatchModel,
  });

  final RawMaterialBatchModel rawMaterialBatchModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Update Raw Material Batch',
        ),
      ),
      body: UpdateBatchRawMaterialBody(
        rawMaterialBatchModel: rawMaterialBatchModel,
      ),
    );
  }
}

class UpdateBatchRawMaterialBody2 extends StatefulWidget {
  const UpdateBatchRawMaterialBody2({
    super.key,
    required this.rawMaterialBatchModel,
  });
  final RawMaterialBatch rawMaterialBatchModel;
  @override
  State<UpdateBatchRawMaterialBody2> createState() =>
      _UpdateBatchRawMaterialBodyState2();
}

class _UpdateBatchRawMaterialBodyState2
    extends State<UpdateBatchRawMaterialBody2> {
  late final TextEditingController _quantityInController;
  late final TextEditingController _realCostController;
  late final TextEditingController _paymentMethodController;
  late final TextEditingController _supplierController;
  late final TextEditingController _notesController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with model values
    _quantityInController = TextEditingController(
      text: widget.rawMaterialBatchModel.quantityIn.toString(),
    );
    _realCostController = TextEditingController(
      text: widget.rawMaterialBatchModel.realCost.toString(),
    );
    _paymentMethodController = TextEditingController(
      text: widget.rawMaterialBatchModel.paymentMethod,
    );
    _supplierController = TextEditingController(
      text: widget.rawMaterialBatchModel.supplier,
    );
    _notesController = TextEditingController(
      text: widget.rawMaterialBatchModel.notes,
    );
  }

  @override
  void dispose() {
    _quantityInController.dispose();
    _realCostController.dispose();
    _paymentMethodController.dispose();
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateRawMaterial() {
    // Validate all form fields
    if (_formKey.currentState!.validate()) {
      // Form is valid, collect the data
      final double quantityIn = double.parse(_quantityInController.text);
      final double realCost = double.parse(_realCostController.text);
      final String paymentMethod = _paymentMethodController.text;
      final String supplier = _supplierController.text;
      final String notes = _notesController.text;

      // Create a map with the data to send to the Cubit
      final Map<String, dynamic> batchData = {
        "quantity_in": quantityIn,
        'real_cost': realCost,
        'payment_method': paymentMethod,
        'supplier': supplier,
        'notes': notes,
      };

      // Call the Cubit to update the raw material batch
      context.read<UpdateBatchRawMaterialCubit>().updateRawMaterialBatch(
        widget.rawMaterialBatchModel.rawMaterialBatchId,
        batchData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      UpdateBatchRawMaterialCubit,
      UpdateBatchRawMaterialState
    >(
      listener: (context, state) {
        if (state is UpdateBatchRawMaterialLoading) {
          // Show a loading indicator (e.g., CircularProgressIndicator in a dialog)
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Updating batch...')));
        } else if (state is UpdateBatchRawMaterialSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // You might want to pop the screen or refresh the previous list here
          // Navigator.pop(context, true); // Pass true to indicate a successful update
        } else if (state is UpdateBatchRawMaterialError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Quantity In Field
              CustomTextField(
                controller: _quantityInController,
                label: const Text('Quantity In'),
                hintText: 'Enter quantity',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Quantity must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Real Cost Field
              CustomTextField(
                controller: _realCostController,
                label: const Text('Real Cost'),
                hintText: 'Enter cost',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Cost must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Payment Method Field
              CustomTextField(
                controller: _paymentMethodController,
                label: const Text('Payment Method'),
                hintText: 'Enter payment method (cash, credit, etc.)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter payment method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Supplier Field
              CustomTextField(
                controller: _supplierController,
                label: const Text('Supplier'),
                hintText: 'Enter supplier name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter supplier';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Notes Field (Optional)
              CustomTextField(
                controller: _notesController,
                label: const Text('Notes (Optional)'),
                hintText: 'Enter any notes',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Update Button
              BlocBuilder<
                UpdateBatchRawMaterialCubit,
                UpdateBatchRawMaterialState
              >(
                builder: (context, state) {
                  return CustomButton(
                    text: state is UpdateBatchRawMaterialLoading
                        ? 'Updating...'
                        : 'Update',
                    onTap: state is UpdateBatchRawMaterialLoading
                        ? null
                        : _updateRawMaterial,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
