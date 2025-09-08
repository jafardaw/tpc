import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/widget/appar_widget,.dart'; // تأكد من المسار الصحيح
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_state.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/widget/fillter_search.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/widget/resault_search_material.dart';

class RawMaterialSearchPage extends StatefulWidget {
  const RawMaterialSearchPage({super.key});

  @override
  State<RawMaterialSearchPage> createState() => _RawMaterialSearchPageState();
}

class _RawMaterialSearchPageState extends State<RawMaterialSearchPage> {
  // المفاتيح وأجهزة التحكم الخاصة بالفلتر تبقى هنا لأنها تدير حالة الفلتر
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _status;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _minStockAlertController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minStockAlertController.dispose();
    super.dispose();
  }

  void _search() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // إغلاق لوحة المفاتيح
      context.read<RawMaterialSearchCubit>().searchRawMaterials(
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        status: _status,
        minPrice: _minPriceController.text.isNotEmpty
            ? double.parse(_minPriceController.text)
            : null,
        maxPrice: _maxPriceController.text.isNotEmpty
            ? double.parse(_maxPriceController.text)
            : null,
        minStockAlert: _minStockAlertController.text.isNotEmpty
            ? double.parse(_minStockAlertController.text)
            : null,
      );
    }
  }

  void _clearFilters() {
    _formKey.currentState!.reset();
    _status = null;

    _nameController.clear();
    _descriptionController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    _minStockAlertController.clear();

    setState(() {}); // لتحديث حالة DropdownButtonFormField

    context
        .read<RawMaterialSearchCubit>()
        .searchRawMaterials(); // بحث بدون فلاتر
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateRawMaterialCubit, UpdateRawmaterialState>(
      listener: (context, state) {
        if (state is UpdateRawMaterialSuccess ||
            state is DeleatRawMaterialSuccess) {
          context.read<RawMaterialSearchCubit>().searchRawMaterials();
        }

        if (state is DeleatRawMaterialSuccess) {
          showCustomSnackBar(
            context,
            state.message,
            color: Palette.primarySuccess,
          );
        } else if (state is DeleatRawMaterialError) {
          showCustomSnackBar(
            context,
            state.message,
            color: Palette.primaryError,
          );
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'بحث المواد الخام',
          ),
        ),
        body: Column(
          children: [
            // شريط الفلاتر القابل للطي
            RawMaterialFiltersSection(
              formKey: _formKey,
              nameController: _nameController,
              descriptionController: _descriptionController,
              status: _status,
              onStatusChanged: (newValue) {
                setState(() {
                  _status = newValue;
                });
              },
              minPriceController: _minPriceController,
              maxPriceController: _maxPriceController,
              minStockAlertController: _minStockAlertController,
              onSearch: _search,
              onClearFilters: _clearFilters,
            ),
            const Divider(height: 1),
            // نتائج البحث
            const Expanded(child: RawMaterialResultsSection()),
          ],
        ),
      ),
    );
  }
}
