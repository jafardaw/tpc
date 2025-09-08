import 'package:flutter/material.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/entities/production_setting.dart';

@immutable
abstract class GetProductionSettingState {}

class GetProductionSettingInitial extends GetProductionSettingState {}

class GetProductionSettingLoading extends GetProductionSettingState {}

class GetProductionSettingLoaded extends GetProductionSettingState {
  final List<ProductionSetting> settings;
  GetProductionSettingLoaded(this.settings);
}

class GetProductionSettingError extends GetProductionSettingState {
  final String errorMessage;
  GetProductionSettingError(this.errorMessage);
}
