abstract class AddProductionSettingState {}

class AddProductionSettingsInitial extends AddProductionSettingState {}

class AddProductionSettingsLoading extends AddProductionSettingState {}

class AddProductionSettingsSuccess extends AddProductionSettingState {}

class AddProductionSettingsFailure extends AddProductionSettingState {
  final String errorMessage;

  AddProductionSettingsFailure(this.errorMessage);
}

class ProductionSettingsUpdating extends AddProductionSettingState {}

class ProductionSettingsUpdated extends AddProductionSettingState {}

class ProductionSettingsUpdateFailed extends AddProductionSettingState {
  final String errorMessage;
  ProductionSettingsUpdateFailed(this.errorMessage);
}

class ProductionSettingsDeleting extends AddProductionSettingState {}

class ProductionSettingsDeleted extends AddProductionSettingState {}

class ProductionSettingsDeleteFailed extends AddProductionSettingState {
  final String errorMessage;
  ProductionSettingsDeleteFailed(this.errorMessage);
}
