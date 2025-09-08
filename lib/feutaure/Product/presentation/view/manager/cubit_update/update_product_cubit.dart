// lib/cubit/Update_raw_material/Update_raw_material_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/cubit_update/update_product_state.dart';
import 'package:tcp212/feutaure/Product/repo/repo_product.dart';

class UpdateProductCubit extends Cubit<UpdateProductState> {
  final ProductListRepo productRepository;

  UpdateProductCubit({required this.productRepository})
    : super(DeleatProductInitial());

  // Future<void> updateawMaterial(Product Product, int id) async {
  //   emit(DeleatProductLoading());
  //   try {
  //     final newProduct = await ProductRepository.UpdateProduct(Product, id);

  //     print('mohamamasdasdasd$newProduct');
  //     emit(DeleatProductSuccess(newProduct));
  //   } on DioException catch (e) {
  //     String errorMessage = ErrorHandler.handleDioError(e);
  //     emit(DeleatroductError(errorMessage));
  //   } catch (error) {
  //     emit(
  //         DeleatroductError(error.toString().replaceFirst('Exception: ', '')));
  //   }
  // }

  Future deleatProduct(int id) async {
    emit(DeleatProductLoading());
    try {
      final message = await productRepository.deleteProduct(id);
      emit(DeleatProductSuccess(message));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(DeleatroductError(errorMessage));
    } catch (error) {
      emit(DeleatroductError(error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
