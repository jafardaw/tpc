// lib/features/production_settings/presentation/cubit/production_settings_state.dart
import 'package:equatable/equatable.dart';
import 'package:tcp212/feutaure/ProductionSettings/data/model/entities/production_setting.dart';

abstract class ProductionSettingsState extends Equatable {
  const ProductionSettingsState();

  @override
  List<Object> get props => [];
}

class ProductionSettingsInitial extends ProductionSettingsState {}

class ProductionSettingsLoading extends ProductionSettingsState {}

class ProductionSettingsLoaded extends ProductionSettingsState {
  final List<ProductionSetting> settings;

  const ProductionSettingsLoaded({required this.settings});

  @override
  List<Object> get props => [settings];
}

class ProductionSettingsError extends ProductionSettingsState {
  final String message;

  const ProductionSettingsError({required this.message});

  @override
  List<Object> get props => [message];
}
