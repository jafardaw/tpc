import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_add/add_raw_material_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/widget/add_raw_material_body.dart';
import 'package:tcp212/feutaure/Row_Material/repo/raw_material_repo.dart';

class AddRawMaterialPage extends StatelessWidget {
  const AddRawMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddRawMaterialCubit(
        rawMaterialRepository: RawMaterialRepository(apiService: ApiService()),
      ),
      child: const AddRawMaterialBody(),
    );
  }
}
