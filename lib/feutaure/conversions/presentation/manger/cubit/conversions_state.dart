import 'package:flutter/material.dart';
import 'package:tcp212/feutaure/conversions/data/model/conversions_model.dart';

@immutable
abstract class ConversionsState {}

class ConversionsInitial extends ConversionsState {}

class ConversionsLoading extends ConversionsState {}

class ConversionsLoaded extends ConversionsState {
  final List<ConversionModel> conversions;
  ConversionsLoaded(this.conversions);
}

class ConversionsError extends ConversionsState {
  final String errorMessage;
  ConversionsError(this.errorMessage);
}

class ConversionBatchLoading extends ConversionsState {}

class ConversionBatchLoaded extends ConversionsState {
  final List<ConversionModel> conversions;

  ConversionBatchLoaded(this.conversions);
}

class ConversionBatchError extends ConversionsState {
  final String message;

  ConversionBatchError(this.message);
}
