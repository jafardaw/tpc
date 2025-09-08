import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/alert_dilog.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/util/styles.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/cusrom_button_card.dart';
import 'package:tcp212/core/widget/empty_widget_view.dart';
import 'package:tcp212/core/widget/error_widget_view.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/manger/cubit/damaged_material_cubit.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/manger/cubit/damaged_material_state.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/view/damaged_material_detail_screen.dart';
import 'package:tcp212/feutaure/damagedmaterial/repo/damaged_material_repository_imp.dart';

class DamagedMaterialsScreen extends StatefulWidget {
  const DamagedMaterialsScreen({super.key});

  @override
  State<DamagedMaterialsScreen> createState() => _DamagedMaterialsScreenState();
}

class _DamagedMaterialsScreenState extends State<DamagedMaterialsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DamagedMaterialsCubit(DamagedMaterialRepositoryImp(ApiService()))
            ..fetchDamagedMaterials(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'Damaged Materials',
          ),
        ),
        body: BlocConsumer<DamagedMaterialsCubit, DamagedMaterialsState>(
          listener: (context, state) {
            if (state is DamagedMaterialDeletedSuccess) {
              setState(() {
                context.read<DamagedMaterialsCubit>().fetchDamagedMaterials();
                Navigator.of(context).pop();
                showCustomSnackBar(
                  context,
                  state.message,
                  color: Palette.primarySuccess,
                );
              });
            } else if (state is DamagedMaterialDeleteError) {
              setState(() {
                Navigator.of(context).pop();

                showCustomSnackBar(
                  context,
                  state.message,
                  color: Palette.primaryError,
                );
              });
            }
          },
          builder: (context, state) {
            if (state is DamagedMaterialsLoading) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2.0),
              );
            } else if (state is DamagedMaterialsLoaded) {
              if (state.damagedMaterials.isEmpty) {
                return EmptyWigetView(
                  message: 'No damaged materials recorded',
                  icon: Icons.inventory_2_outlined,
                );
              }
              return RefreshIndicator(
                color: Colors.orange,
                onRefresh: () async {
                  context.read<DamagedMaterialsCubit>().fetchDamagedMaterials();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.damagedMaterials.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final material = state.damagedMaterials[index];
                    final materialName = material.materialType == 'raw'
                        ? material.rawMaterialBatch?.rawMaterial?.name ??
                              'Unknown raw material'
                        : material.productBatch?.product?.name ??
                              'Unknown product/semi-finished';

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DamagedMaterialDetailScreen(
                              damagedMaterial: material,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: material.materialType == 'raw'
                                          ? Colors.blue[50]
                                          : Colors.purple[50],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: material.materialType == 'raw'
                                            ? Colors.blue[100]!
                                            : Colors.purple[100]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      material.materialType == 'raw'
                                          ? 'Raw Material'
                                          : 'Semi-Finished',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: material.materialType == 'raw'
                                            ? Colors.blue[800]
                                            : Colors.purple[800],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showCustomAlertDialog(
                                        context: context,
                                        title: 'Alert!',
                                        content: 'Are you sure Delete??',
                                        actions: [
                                          ButtonINCard(
                                            onPressed: () {
                                              context
                                                  .read<DamagedMaterialsCubit>()
                                                  .deleteDamagedMaterial(
                                                    material.damagedMaterialId,
                                                  );
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            label: Text(
                                              'Delete',
                                              style: Styles.textStyle18
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                          ButtonINCard(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.green,
                                            ),
                                            label: Text(
                                              'cancel',
                                              style: Styles.textStyle18
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 28,
                                    ),
                                  ),
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange[400],
                                    size: 28,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                context,
                                'Material:',
                                materialName,
                                icon: Icons.inventory_2_outlined,
                              ),
                              _buildInfoRow(
                                context,
                                'Quantity:',
                                '${material.quantity}',
                                icon: Icons.scale_outlined,
                              ),
                              _buildInfoRow(
                                context,
                                'Lost Cost:',
                                NumberFormat.currency(
                                  locale: 'en',
                                  symbol: 'KWD',
                                ).format(material.lostCost),
                                icon: Icons.attach_money_outlined,
                                valueColor: Colors.red[600],
                              ),
                              _buildInfoRow(
                                context,
                                'Date:',
                                formatDate(material.createdAt),
                                icon: Icons.calendar_today_outlined,
                              ),
                              if (material.notes != null &&
                                  material.notes!.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.note_outlined,
                                      size: 20,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Notes:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[600],
                                                ),
                                          ),
                                          Text(
                                            material.notes!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.grey[800],
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is DamagedMaterialsError) {
              return ErrorWidetView(
                message: state.message,
                onPressed: () {
                  context.read<DamagedMaterialsCubit>().fetchDamagedMaterials();
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[500]),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor ?? Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat(
        'yyyy/MM/dd - hh:mm a',
        'en',
      ).format(dateTime.toLocal());
    } catch (e) {
      return dateString;
    }
  }
}
