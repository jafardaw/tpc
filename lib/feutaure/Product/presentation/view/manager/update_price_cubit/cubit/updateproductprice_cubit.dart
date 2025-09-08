import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:tcp212/core/util/error/error_handling.dart';
import 'package:tcp212/feutaure/Product/repo/repo_product.dart';

part 'updateproductprice_state.dart';

class UpdateproductpriceCubit extends Cubit<UpdateproductpriceState> {
  UpdateproductpriceCubit(this.rawMaterialRepository)
    : super(UpdateproductpriceInitial());

  final ProductListRepo rawMaterialRepository;

  Future<void> updateProducePrice() async {
    emit(UpdateproductpriceLoading());

    try {
      await rawMaterialRepository.updateproductprice();
      emit(const UpdateproductpriceSucsess(message: 'تم تحديث الأسعار بنجاح'));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(UpdateproductpriceError(message: errorMessage));
    } catch (error) {
      emit(
        UpdateproductpriceError(
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
