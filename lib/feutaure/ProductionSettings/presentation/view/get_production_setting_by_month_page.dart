import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/const.dart'; // Make sure productionSettingsRepo is correctly initialized here.
import 'package:tcp212/core/util/func/alert_dilog.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/empty_widget_view.dart';
import 'package:tcp212/core/widget/error_widget_view.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/get_production_setting_by_month_cubit.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/get_production_setting_by_month_state.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/production_setting_detalis.dart';
import 'package:tcp212/feutaure/ProductionSettings/presentation/view/widget/production_settings_card.dart'; // Your helper widget

class ProductionSettingsOverviewScreen extends StatefulWidget {
  const ProductionSettingsOverviewScreen({super.key});

  @override
  State<ProductionSettingsOverviewScreen> createState() =>
      _ProductionSettingsOverviewScreenState();
}

class _ProductionSettingsOverviewScreenState
    extends State<ProductionSettingsOverviewScreen> {
  late int _selectedMonth;
  late int _selectedYear;
  // Hold a reference to the Cubit instance
  late GetProductionSettingCubit _productionCubit;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now().month;
    _selectedYear = DateTime.now().year;

    // Initialize the Cubit here and perform the initial fetch
    _productionCubit = GetProductionSettingCubit(
      repository: productionSettingsRepo,
    );
    _productionCubit.fetchProductionSettingsByMonthYear(
      _selectedMonth,
      _selectedYear,
    );
  }

  @override
  void dispose() {
    _productionCubit.close(); // Don't forget to close the cubit!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Monthly Production Overview',
        ),
      ),
      // Use the pre-initialized Cubit instance
      body: BlocProvider<GetProductionSettingCubit>.value(
        value: _productionCubit, // Provide the existing cubit instance
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _selectedMonth,
                      decoration: InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                          color: Colors.teal,
                        ),
                      ),
                      items: List.generate(12, (index) => index + 1)
                          .map(
                            (month) => DropdownMenuItem(
                              value: month,
                              child: Text('$month'),
                            ),
                          )
                          .toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedMonth = newValue;
                          });
                          // Trigger new fetch when month changes
                          _productionCubit.fetchProductionSettingsByMonthYear(
                            _selectedMonth,
                            _selectedYear,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _selectedYear,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.date_range,
                          color: Colors.teal,
                        ),
                      ),
                      items:
                          List.generate(
                                20,
                                (index) => DateTime.now().year - 2 + index,
                              )
                              .map(
                                (year) => DropdownMenuItem(
                                  value: year,
                                  child: Text('$year'),
                                ),
                              )
                              .toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedYear = newValue;
                          });
                          // Trigger new fetch when year changes
                          _productionCubit.fetchProductionSettingsByMonthYear(
                            _selectedMonth,
                            _selectedYear,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Removed the explicit "Show Data" button and search IconButton.
            // Data will now refresh automatically on month/year selection change.
            const SizedBox(height: 10),
            Expanded(
              child:
                  BlocConsumer<
                    GetProductionSettingCubit,
                    GetProductionSettingState
                  >(
                    listener: (context, state) {
                      if (state is GetProductionSettingError) {
                        return showCustomAlertDialog(
                          context: context,
                          title: 'Try again',
                          content: 'Select month and year to view data',
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is GetProductionSettingLoading) {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        );
                      } else if (state is GetProductionSettingLoaded) {
                        if (state.settings.isEmpty) {
                          return EmptyWigetView(
                            icon: Icons.date_range,
                            message:
                                'No production settings found for $_selectedMonth/$_selectedYear.',
                          );
                        }
                        return ListView.builder(
                          itemCount: state.settings.length,
                          itemBuilder: (context, index) {
                            final setting = state.settings[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductionSettingDetailPage(
                                          setting: state.settings[index],
                                        ),
                                  ),
                                );
                              },
                              child: ProductionSettingsByMonthCard(
                                setting: setting,
                              ),
                            );
                          },
                        );
                      } else if (state is GetProductionSettingError) {
                        return ErrorWidetView(
                          message: ' ${state.errorMessage}',
                          onPressed: () {
                            _productionCubit.fetchProductionSettingsByMonthYear(
                              _selectedMonth,
                              _selectedYear,
                            );
                          },
                        );
                      }
                      return const Center(
                        child: Text('Select month and year to view data.'),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
