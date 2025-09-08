// في ملف add_new_product_state.dart
import 'package:equatable/equatable.dart';

abstract class AddNewProductState extends Equatable {
  const AddNewProductState();

  @override
  List<Object?> get props => [];
}

class AddNewProductInitial extends AddNewProductState {}

class AddNewProductLoading extends AddNewProductState {}

class AddNewProductSuccess extends AddNewProductState {
  final String message;
  const AddNewProductSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddNewProductFailure extends AddNewProductState {
  final String errMessage;
  const AddNewProductFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
