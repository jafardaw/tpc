import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/custom_button.dart';
import 'package:tcp212/core/widget/custom_field.dart';

import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_cubit.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_state.dart'; // تأكد من المسار الصحيح

class AddProductionSettingsScreen extends StatefulWidget {
  const AddProductionSettingsScreen({super.key});

  @override
  State<AddProductionSettingsScreen> createState() =>
      _AddProductionSettingsScreenState();
}

class _AddProductionSettingsScreenState
    extends State<AddProductionSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _totalProductionController =
      TextEditingController();
  String _selectedType = 'estimated';
  final TextEditingController _profitRatioController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          title: 'Add Production Settings',
          automaticallyImplyLeading: true,
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            AddProductionSettingsCubit(repository: productionSettingsRepo),
        child:
            BlocConsumer<AddProductionSettingsCubit, AddProductionSettingState>(
              listener: (context, state) {
                if (state is AddProductionSettingsSuccess) {
                  showCustomSnackBar(
                    context,
                    'Production settings added successfully!',
                    color: Palette.primarySuccess,
                  );
                } else if (state is AddProductionSettingsFailure) {
                  showCustomSnackBar(
                    context,
                    state.errorMessage,
                    color: Palette.primaryDark,
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Total Production Field
                        Text(
                          'Total Production',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _totalProductionController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter total production';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Type Dropdown
                        Text(
                          'Type',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedType,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              items: <String>['estimated', 'real']
                                  .map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value[0].toUpperCase() +
                                            value.substring(1),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    );
                                  })
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedType = newValue!;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a type';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Profit Ratio Field
                        Text(
                          'Profit Ratio',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _profitRatioController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter profit ratio';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Month and Year Row
                        Row(
                          children: [
                            // Month Field
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Month',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextField(
                                    controller: _monthController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Invalid';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Year Field
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Year',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextField(
                                    controller: _yearController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Invalid';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Notes Field
                        Text(
                          'Notes (Optional)',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _notesController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 30),

                        // Submit Button
                        if (state is AddProductionSettingsLoading)
                          const Center(
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          )
                        else
                          CustomButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<AddProductionSettingsCubit>()
                                    .addProductionSettings(
                                      totalProduction: double.parse(
                                        _totalProductionController.text,
                                      ),
                                      type: _selectedType,
                                      profitRatio: double.parse(
                                        _profitRatioController.text,
                                      ),
                                      month: int.parse(_monthController.text),
                                      year: int.parse(_yearController.text),
                                      notes: _notesController.text.isNotEmpty
                                          ? _notesController.text
                                          : null,
                                    );
                              }
                            },
                            text: 'Save Production Settings',
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }

  @override
  void dispose() {
    _totalProductionController.dispose();
    _profitRatioController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
