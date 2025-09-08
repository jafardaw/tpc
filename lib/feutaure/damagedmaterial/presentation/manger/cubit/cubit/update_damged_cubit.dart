import 'package:bloc/bloc.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/manger/cubit/cubit/update_damged_state.dart';
import 'package:tcp212/feutaure/damagedmaterial/repo/damaged_material_repository_imp.dart';

class UpdateDamgedCubit extends Cubit<UpdateDamgedState> {
  final DamagedMaterialRepositoryImp _damagedMaterialRepository;

  UpdateDamgedCubit(this._damagedMaterialRepository)
    : super(UpdateDamgedInitial());
  Future<void> updateDamagedMaterial(
    int damagedMaterialId, {
    required double quantity,
    String? notes,
  }) async {
    emit(DamagedMaterialUpdating()); // Indicate update is in progress
    try {
      final updatedMaterial = await _damagedMaterialRepository
          .updateDamagedMaterial(
            damagedMaterialId,
            quantity: quantity,
            notes: notes,
          );
      emit(
        DamagedMaterialUpdateSuccess(
          updatedMaterial,
          'تم تحديث المادة التالفة بنجاح!',
        ),
      );
    } catch (e) {
      emit(DamagedMaterialUpdateError(e.toString()));
    }
  }
}
