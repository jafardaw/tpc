// lib/features/production_settings/presentation/pages/production_settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/alert_dilog.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/error_widget_view.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_cubit.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_state.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/get_product_setting_cubit.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/get_product_setting_state.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/add_production_page.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/edit_production_setting_page.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/production_setting_detalis.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/widget/production_setting_card.dart';
import 'package:tcp212/feutaure/ProductionSettings/repo/production_settings_repo.dart';

import '../../../../core/util/func/float_action_botton.dart';

class ProductionSettingsPage extends StatelessWidget {
  const ProductionSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductionSettingsCubit(
            repository: ProductionSettingsRepo(ApiService()),
          )..fetchProductionSettings(),
        ),
        BlocProvider(
          create: (context) => AddProductionSettingsCubit(
            repository: ProductionSettingsRepo(ApiService()),
          ),
        ),
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            title: 'Production Settings',
            automaticallyImplyLeading: true,
          ),
        ),
        body: BlocListener<AddProductionSettingsCubit, AddProductionSettingState>(
          listener: (context, state) {
            if (state is ProductionSettingsDeleted) {
              showCustomSnackBar(context, 'Deleted successfully!');
              Navigator.of(context).pop();
              context.read<ProductionSettingsCubit>().fetchProductionSettings();
            } else if (state is ProductionSettingsDeleteFailed) {
              showCustomSnackBar(
                context,
                'Delete failed: ${state.errorMessage}',
              );
            }
          },
          child: BlocConsumer<ProductionSettingsCubit, ProductionSettingsState>(
            listener: (context, state) {
              if (state is ProductionSettingsLoaded) {
                // Close the dialog

                showCustomSnackBar(
                  context,
                  'get Production Setting Success',
                  color: Palette.primarySuccess,
                );
              } else if (state is ProductionSettingsError) {
                showCustomSnackBar(
                  context,
                  state.message,
                  color: Palette.primaryError,
                );
              }
            },
            builder: (context, state) {
              if (state is ProductionSettingsLoading) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                );
              } else if (state is ProductionSettingsLoaded) {
                if (state.settings.isEmpty) {
                  return const Center(
                    child: Text('No production data available.'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  itemCount: state.settings.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductionSettingDetailPage(
                              setting: state.settings[index],
                            ),
                          ),
                        );
                      },
                      child: ProductionSettingCard(
                        setting: state.settings[index],
                        onDelete: () {
                          showCustomAlertDialog(
                            context: context,
                            title:
                                'Be careful', // Fixed typo from "cerfull" to "careful"
                            content:
                                'Are you sure you want to delete this production setting?',
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(
                                  context,
                                ).pop(), // Cancel action
                                child: const Text(
                                  'Cancel', // Arabic for "Cancel"
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await context
                                      .read<AddProductionSettingsCubit>()
                                      .deleteProductionSettings(
                                        state
                                            .settings[index]
                                            .productionSettingsId,
                                      )
                                      .then((_) {
                                        context
                                            .read<ProductionSettingsCubit>()
                                            .fetchProductionSettings();
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Confirm', // Arabic for "Confirm"
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProductionSettingsScreen(
                                    settingsId: state
                                        .settings[index]
                                        .productionSettingsId,
                                    productionSetting: state.settings[index],
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else if (state is ProductionSettingsError) {
                return ErrorWidetView(
                  message: state.message,
                  onPressed: () {
                    context
                        .read<ProductionSettingsCubit>()
                        .fetchProductionSettings();
                  },
                );
              }
              return const Center(
                child: Text('Press the button to load production settings.'),
              );
            },
          ),
        ),
        floatingActionButton: buildFloatactionBouttonW(
          context,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductionSettingsScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
