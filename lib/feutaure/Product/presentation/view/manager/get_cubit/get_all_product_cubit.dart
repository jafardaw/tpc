import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/get_cubit/get_all_product_state.dart';
import 'package:tcp212/feutaure/Product/repo/repo_product.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final ProductListRepo _repository;

  ProductListCubit(this._repository) : super(ProductListInitial());

  Future<void> fetchProducts() async {
    emit(ProductListLoading());
    try {
      final products = await _repository.fetchProducts();
      emit(ProductListLoaded(products: products));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(ProductListError(errorMessage: errorMessage));
    } catch (error) {
      emit(
        ProductListError(
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
