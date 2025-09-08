import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/feutaure/Row_Material/data/add_raw_material_model.dart';
import 'package:tcp212/feutaure/Row_Material/data/get_raw_material_model.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_state.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/widget/update_raw_material_body.dart';

class UpdateRawMaterialView extends StatefulWidget {
  const UpdateRawMaterialView({super.key, required this.rowmaterial});

  final GetRawMaterialModel rowmaterial;

  @override
  State<UpdateRawMaterialView> createState() => _UpdateRawMaterialViewState();
}

class _UpdateRawMaterialViewState extends State<UpdateRawMaterialView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();
  late final TextEditingController _priceController = TextEditingController();
  late final TextEditingController _statusController = TextEditingController();
  late final TextEditingController _minStockAlertController =
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

  @override
  void initState() {
    _nameController.text = widget.rowmaterial.name;
    _descriptionController.text = widget.rowmaterial.description;
    _priceController.text = widget.rowmaterial.price.toString();
    _statusController.text = widget.rowmaterial.status;
    _minStockAlertController.text = widget.rowmaterial.minimumStockAlert
        .toString();
    super.initState();
  }

  void _updateRawMaterial(int id) {
    if (_formKey.currentState!.validate()) {
      final rawMaterial = RawMaterial(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        status: _statusController.text,
        minimumStockAlert: int.tryParse(_minStockAlertController.text) ?? 0,
      );
      context.read<UpdateRawMaterialCubit>().updateawMaterial(rawMaterial, id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateRawMaterialCubit, UpdateRawmaterialState>(
      listener: (context, state) {
        if (state is UpdateRawMaterialSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UpdateRawMaterialError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'update RawMaterial',
          ),
        ),
        body: UpdateRawmaterialBody(
          formKey: _formKey,
          nameController: _nameController,
          descriptionController: _descriptionController,
          priceController: _priceController,
          statusController: _statusController,
          minStockAlertController: _minStockAlertController,
          onUpdatePressed: () =>
              _updateRawMaterial(widget.rowmaterial.rawMaterialId),
        ),
      ),
    );
  }
}
