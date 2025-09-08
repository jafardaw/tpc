import 'package:bloc/bloc.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/manger/cubit/damaged_material_state.dart';
import 'package:tcp212/feutaure/damagedmaterial/repo/damaged_material_repository_imp.dart';

class DamagedMaterialsCubit extends Cubit<DamagedMaterialsState> {
  final DamagedMaterialRepositoryImp _damagedMaterialRepository;

  DamagedMaterialsCubit(this._damagedMaterialRepository)
    : super(DamagedMaterialsInitial());

  Future<void> fetchDamagedMaterials() async {
    emit(DamagedMaterialsLoading());
    try {
      final materials = await _damagedMaterialRepository.getDamagedMaterials();
      emit(DamagedMaterialsLoaded(materials));
    } catch (e) {
      emit(DamagedMaterialsError(e.toString()));
    }
  }

  Future<void> deleteDamagedMaterial(int damagedMaterialId) async {
    emit(DamagedMaterialDeleting()); // Indicate deletion is in progress
    try {
      await _damagedMaterialRepository.deleteDamagedMaterial(damagedMaterialId);
      emit(DamagedMaterialDeletedSuccess('تم حذف المادة التالفة بنجاح!'));
    } catch (e) {
      emit(DamagedMaterialDeleteError(e.toString()));
    }
  }
}
