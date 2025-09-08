import 'package:bloc/bloc.dart';
import 'package:tcp212/feutaure/Row_Material/data/get_raw_material_model.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_state.dart';
import 'package:tcp212/feutaure/Row_Material/repo/raw_material_repo.dart'; // تأكد من المسار الصحيح للموديل

class GetRawMaterialsCubit extends Cubit<GetRawMaterialsState> {
  final RawMaterialRepository rawMaterialRepository;
  List<GetRawMaterialModel> allRawMaterials = []; // تخزين جميع المواد الخام

  GetRawMaterialsCubit({required this.rawMaterialRepository})
    : super(GetRawMaterialsInitial());

  Future<void> fetchRawMaterials() async {
    emit(GetRawMaterialsLoading());
    try {
      allRawMaterials = await rawMaterialRepository.getRawMaterials();
      emit(GetRawMaterialsSuccess(allRawMaterials));
    } catch (e) {
      String errorMessage;
      if (e is Exception) {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      } else {
        errorMessage = e.toString();
      }
      emit(GetRawMaterialsError(errorMessage));
    }
  }

  void filterRawMaterials(String status) {
    if (allRawMaterials.isEmpty) return;

    List<GetRawMaterialModel> filteredList;
    if (status == 'All') {
      filteredList = allRawMaterials;
    } else {
      if (status == 'Used') {
        status = 'used';
      } else {
        status = 'unused';
      }
      // تحويل التسمية العربية إلى القيمة الفعلية في البيانات
      filteredList = allRawMaterials
          .where((material) => material.status == status)
          .toList();
    }

    emit(GetRawMaterialsSuccess(filteredList));
  }
}
