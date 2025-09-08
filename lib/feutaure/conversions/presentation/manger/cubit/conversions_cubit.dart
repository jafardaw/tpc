import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/feutaure/conversions/presentation/manger/cubit/conversions_state.dart';
import 'package:tcp212/feutaure/conversions/repo/conversion_repo.dart';

class ConversionsCubit extends Cubit<ConversionsState> {
  final ConversionsRepoImpl repository;

  ConversionsCubit({required this.repository}) : super(ConversionsInitial());

  Future<void> fetchAllConversions() async {
    emit(ConversionsLoading());
    try {
      final conversions = await repository.getAllConversions();
      emit(ConversionsLoaded(conversions));
    } catch (e) {
      emit(ConversionsError(e.toString()));
    }
  }

  Future<void> getConversionsByProductBatch(int productBatchId) async {
    emit(ConversionBatchLoading());
    try {
      final conversions = await repository.getConversionsByProductBatch(
        productBatchId,
      );
      emit(ConversionBatchLoaded(conversions));
    } catch (e) {
      emit(ConversionBatchError(e.toString()));
    }
  }
}
