part of 'updateproductprice_cubit.dart';

sealed class UpdateproductpriceState extends Equatable {
  const UpdateproductpriceState();

  @override
  List<Object> get props => [];
}

final class UpdateproductpriceInitial extends UpdateproductpriceState {}

final class UpdateproductpriceLoading extends UpdateproductpriceState {}

final class UpdateproductpriceSucsess extends UpdateproductpriceState {
  final String message;

  const UpdateproductpriceSucsess({required this.message});
}

final class UpdateproductpriceError extends UpdateproductpriceState {
  final String message;

  const UpdateproductpriceError({required this.message});
}
