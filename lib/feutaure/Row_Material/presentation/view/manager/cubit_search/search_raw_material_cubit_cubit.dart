import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_state.dart';
import 'package:tcp212/feutaure/Row_Material/repo/raw_material_repo.dart';

class RawMaterialSearchCubit extends Cubit<RawMaterialSearchState> {
  final RawMaterialRepository repository;

  RawMaterialSearchCubit({required this.repository})
    : super(RawMaterialSearchInitial());

  Future<void> searchRawMaterials({
    String? name,
    String? description,
    String? status,
    double? minPrice,
    double? maxPrice,
    double? minStockAlert,
  }) async {
    emit(RawMaterialSearchLoading());

    try {
      final results = await repository.searchRawMaterials(
        name: name,
        description: description,
        status: status,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minStockAlert: minStockAlert,
      );
      emit(RawMaterialSearchSuccess(results));
    } catch (e) {
      emit(RawMaterialSearchError(e.toString()));
    }
  }
}
