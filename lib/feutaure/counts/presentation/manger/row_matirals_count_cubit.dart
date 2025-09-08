// lib/feutaure/counts/presentation/cubit/raw_materials_count_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/feutaure/counts/presentation/manger/row_counts_state.dart';
import 'package:tcp212/feutaure/counts/repo/products_count_repository_impl.dart';

class RawMaterialsCountCubit extends Cubit<RawMaterialsCountState> {
  final ProductsCountRepositoryImpl repository;

  RawMaterialsCountCubit({required this.repository})
    : super(RawMaterialsCountInitial());

  Future<void> fetchRawMaterialsCount() async {
    emit(RawMaterialsCountLoading());
    try {
      final rawMaterialsCount = await repository.getRawMaterialsCount();
      emit(RawMaterialsCountLoaded(count: rawMaterialsCount.count));
    } catch (e) {
      emit(RawMaterialsCountError(message: e.toString()));
    }
  }
}
