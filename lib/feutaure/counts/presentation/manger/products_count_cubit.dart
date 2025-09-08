// lib/features/products_count/presentation/cubit/products_count_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/feutaure/counts/repo/products_count_repository_impl.dart';

part 'products_count_state.dart';

class ProductsCountCubit extends Cubit<ProductsCountState> {
  final ProductsCountRepositoryImpl repository;

  ProductsCountCubit({required this.repository})
    : super(ProductsCountInitial());

  Future<void> fetchProductsCount() async {
    emit(ProductsCountLoading());
    try {
      final productsCount = await repository.getProductsCount();
      emit(ProductsCountLoaded(count: productsCount.count));
    } catch (e) {
      emit(ProductsCountError(message: e.toString()));
    }
  }
}
