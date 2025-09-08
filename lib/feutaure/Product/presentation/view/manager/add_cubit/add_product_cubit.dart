import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/add_cubit/add_product_state.dart';
import 'package:tcp212/feutaure/Product/repo/repo_product.dart';

class AddNewProductCubit extends Cubit<AddNewProductState> {
  final ProductListRepo rawMaterialRepository;

  AddNewProductCubit({required this.rawMaterialRepository})
    : super(AddNewProductInitial());

  Future<void> addNewProduct(Map<String, dynamic> body) async {
    emit(AddNewProductLoading());
    try {
      await rawMaterialRepository.addNewProduct(body);
      emit(const AddNewProductSuccess('تم إضافة المنتج بنجاح!'));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(AddNewProductFailure(errorMessage));
    } catch (error) {
      emit(
        AddNewProductFailure(error.toString().replaceFirst('Exception: ', '')),
      );
    }
  }
}
