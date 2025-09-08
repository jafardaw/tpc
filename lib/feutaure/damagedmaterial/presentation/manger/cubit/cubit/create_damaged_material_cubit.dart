import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/feutaure/damagedmaterial/presentation/manger/cubit/cubit/create_damaged_material_state.dart';
import 'package:tcp212/feutaure/damagedmaterial/repo/damaged_material_repository_imp.dart';

class CreateDamagedMaterialCubit extends Cubit<CreateDamagedMaterialState> {
  final DamagedMaterialRepositoryImp _damagedMaterialRepository;

  CreateDamagedMaterialCubit(this._damagedMaterialRepository)
    : super(CreateDamagedMaterialInitial());

  Future<void> createDamagedMaterial({
    int? rawMaterialBatchId,
    int? productBatchId,
    required double quantity,
  }) async {
    emit(CreateDamagedMaterialLoading());
    try {
      final newMaterial = await _damagedMaterialRepository
          .createDamagedMaterial(
            rawMaterialBatchId: rawMaterialBatchId,
            productBatchId: productBatchId,
            quantity: quantity,
          );
      emit(
        CreateDamagedMaterialSuccess(
          newMaterial,
          'تم تسجيل المادة التالفة بنجاح!',
        ),
      );
    } catch (e) {
      emit(CreateDamagedMaterialError(e.toString()));
    }
  }
}
