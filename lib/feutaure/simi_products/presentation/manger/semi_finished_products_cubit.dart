import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/simi_products/data/model/simi_product_model.dart';
import 'package:tcp212/feutaure/simi_products/repo/semi_finished_products_repository_impl.dart';
part 'semi_finished_products_state.dart';

class SemiFinishedProductsCubit extends Cubit<SemiFinishedProductsState> {
  final SemiFinishedProductsRepositoryImpl repository;

  SemiFinishedProductsCubit(this.repository)
    : super(SemiFinishedProductsInitial());

  Future<void> getSemiFinishedProducts() async {
    emit(SemiFinishedProductsLoading());
    try {
      final products = await repository.getSemiFinishedProducts();
      emit(SemiFinishedProductsLoaded(products));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(SemiFinishedProductsError(errorMessage));
    } catch (error) {
      emit(SemiFinishedProductsError(error.toString()));
    }
  }
}
