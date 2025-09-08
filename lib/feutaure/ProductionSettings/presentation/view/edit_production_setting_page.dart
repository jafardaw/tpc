// lib/feutaure/ProductionSettings/presentation/pages/edit_production_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/const.dart'; // تأكد من أن هذا الملف يزود productionSettingsRepo
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/entities/production_setting.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_cubit.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_state.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/get_product_setting_cubit.dart';
// import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/get_product_setting_cubit.dart'; // لم نعد نستخدم هذا الكيوبت مباشرة هنا لتهيئة البيانات

class EditProductionSettingsScreen extends StatefulWidget {
  final int settingsId;
  final ProductionSetting productionSetting; // تم تمرير البيانات مباشرة

  const EditProductionSettingsScreen({
    super.key,
    required this.settingsId,
    required this.productionSetting,
  });

  @override
  State<EditProductionSettingsScreen> createState() =>
      _EditProductionSettingsScreenState();
}

class _EditProductionSettingsScreenState
    extends State<EditProductionSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _totalProductionController;
  late TextEditingController _profitRatioController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    // تهيئة الـ controllers بالبيانات التي تم تمريرها
    _totalProductionController = TextEditingController(
      text: widget.productionSetting.totalProduction.toString(),
    );
    _profitRatioController = TextEditingController(
      text: widget.productionSetting.profitRatio.toString(),
    );
    _notesController = TextEditingController(
      text: widget.productionSetting.notes,
    ); // تأكد من التعامل مع القيمة null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Edit Production Settings',
        ),
      ),
      body: BlocProvider(
        // ضع BlocProvider هنا لكي يكون AddProductionSettingsCubit متاحًا لـ EditPageBody
        create: (context) => AddProductionSettingsCubit(
          repository: productionSettingsRepo,
        ), // تأكد أن productionSettingsRepo متاح من const.dart
        child: EditPageBody(
          formKey: _formKey,
          totalProductionController: _totalProductionController,
          profitRatioController: _profitRatioController,
          notesController: _notesController,
          settingsId: widget.settingsId, // تمرير settingsId
        ),
      ),
    );
  }

  @override
  void dispose() {
    _totalProductionController.dispose();
    _profitRatioController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class EditPageBody extends StatelessWidget {
  const EditPageBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController totalProductionController,
    required TextEditingController profitRatioController,
    required TextEditingController notesController,
    required this.settingsId, // إضافة settingsId
  }) : _formKey = formKey,
       _totalProductionController = totalProductionController,
       _profitRatioController = profitRatioController,
       _notesController = notesController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _totalProductionController;
  final TextEditingController _profitRatioController;
  final TextEditingController _notesController;
  final int settingsId; // استخدمها هنا مباشرة

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductionSettingsCubit, AddProductionSettingState>(
      listener: (context, state) {
        if (state is ProductionSettingsUpdated) {
          showCustomSnackBar(
            context,
            'Settings updated successfully!',
            color: Palette.primarySuccess,
          );

          Navigator.pop(context, true);
          context.read<ProductionSettingsCubit>().fetchProductionSettings();
        } else if (state is ProductionSettingsUpdateFailed) {
          showCustomSnackBar(
            context,
            'Failed to update settings: ${state.errorMessage}',
            color: Palette.primarySuccess,
          );
        }
      },
      builder: (context, state) {
        if (state is ProductionSettingsUpdating) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2.0),
          );
        } else {
          // عرض الفورم في جميع الحالات الأخرى (Initial, Success, Failure)
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modify the production details below:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _totalProductionController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Total Production',
                      hintText: 'Enter new total production',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(
                        Icons.factory_outlined,
                        color: Colors.deepPurple,
                      ),
                      filled: true,
                      fillColor: Colors.deepPurple.shade50,
                    ),
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
                  TextFormField(
                    controller: _profitRatioController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Profit Ratio',
                      hintText: 'Enter new profit ratio (e.g., 0.15)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(
                        Icons.trending_up,
                        color: Colors.deepPurple,
                      ),
                      filled: true,
                      fillColor: Colors.deepPurple.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter profit ratio';
                      }
                      final ratio = double.tryParse(value);
                      if (ratio == null || ratio < 0 || ratio > 1) {
                        return 'Please enter a valid ratio between 0 and 1';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Add any relevant notes here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(
                        Icons.notes,
                        color: Colors.deepPurple,
                      ),
                      filled: true,
                      fillColor: Colors.deepPurple.shade50,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<AddProductionSettingsCubit>()
                              .updateProductionSettings(
                                id: settingsId, // استخدام settingsId
                                totalProduction: double.parse(
                                  _totalProductionController.text,
                                ),
                                profitRatio: double.parse(
                                  _profitRatioController.text,
                                ),
                                notes: _notesController.text.isNotEmpty
                                    ? _notesController.text
                                    : null,
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
