// lib/cubit/add_raw_material/add_raw_material_cubit.dart
import 'package:bloc/bloc.dart';

import 'package:tcp212/feutaure/Row_Material/data/add_raw_material_model.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_add/add_raw_material_state.dart';
import 'package:tcp212/feutaure/Row_Material/repo/raw_material_repo.dart';

class AddRawMaterialCubit extends Cubit<AddRawMaterialState> {
  final RawMaterialRepository rawMaterialRepository;

  AddRawMaterialCubit({required this.rawMaterialRepository})
    : super(AddRawMaterialInitial());

  Future<void> addRawMaterial(RawMaterial rawMaterial) async {
    emit(AddRawMaterialLoading());
    try {
      final newRawMaterial = await rawMaterialRepository.addRawMaterial(
        rawMaterial,
      );

      print('mohamamasdasdasd$newRawMaterial');
      emit(AddRawMaterialSuccess(newRawMaterial));
    } catch (e) {
      final errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'حدث خطأ غير متوقع';
      emit(AddRawMaterialError(errorMessage));
    }
  }
}
