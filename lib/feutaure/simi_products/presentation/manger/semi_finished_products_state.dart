part of 'semi_finished_products_cubit.dart';

abstract class SemiFinishedProductsState extends Equatable {
  const SemiFinishedProductsState();

  @override
  List<Object> get props => [];
}

class SemiFinishedProductsInitial extends SemiFinishedProductsState {}

class SemiFinishedProductsLoading extends SemiFinishedProductsState {}

class SemiFinishedProductsLoaded extends SemiFinishedProductsState {
  final List<SimiProductModel> products;

  const SemiFinishedProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class SemiFinishedProductsError extends SemiFinishedProductsState {
  final String message;

  const SemiFinishedProductsError(this.message);

  @override
  List<Object> get props => [message];
}
