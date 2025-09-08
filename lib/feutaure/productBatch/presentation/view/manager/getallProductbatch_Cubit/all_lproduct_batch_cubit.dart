import 'package:bloc/bloc.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/manager/getallProductbatch_Cubit/get_all_product_batch_state.dart';
import 'package:tcp212/feutaure/productBatch/repo/repo_product_batch.dart';

class ProductBatchCubit extends Cubit<ProductBatchState> {
  final ProductBatchRepo _repository;

  ProductBatchCubit(this._repository) : super(ProductBatchInitial());

  Future<void> fetchAllProductBatches() async {
    emit(ProductBatchLoading());
    try {
      final batches = await _repository.fetchAllProductBatches();
      emit(ProductBatchLoaded(batches: batches));
    } catch (e) {
      emit(ProductBatchError(errorMessage: e.toString()));
    }
  }

  /// تجيب الـ batches حسب productId
  Future<void> fetchProductBatchesById(int id) async {
    emit(ProductBatchByidLoading());
    try {
      final response = await _repository.fetchProductBatchesById(id);
      emit(ProductBatchByidLoaded(response));
    } catch (e) {
      emit(ProductBatchByidError(e.toString()));
    }
  }
}
