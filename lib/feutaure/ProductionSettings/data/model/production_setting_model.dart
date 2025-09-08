// lib/features/production_settings/data/models/production_setting_model.dart

import 'package:tcp212/feutaure/ProductionSettings/data/model/entities/production_setting.dart';

class ProductionSettingModel extends ProductionSetting {
  const ProductionSettingModel({
    required super.productionSettingsId,
    required super.userId,
    required super.totalProduction,
    required super.type,
    required super.profitRatio,
    required super.notes,
    required super.month,
    required super.year,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductionSettingModel.fromJson(Map<String, dynamic> json) {
    return ProductionSettingModel(
      productionSettingsId: json['production_settings_id'] as int,
      userId: json['user_id'] as int,
      totalProduction: double.parse(json['total_production'] as String),
      type: json['type'] as String,
      profitRatio: double.parse(json['profit_ratio'] as String),
      notes: json['notes'] as String,
      month: json['month'] as int,
      year: int.parse(json['year'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'production_settings_id': productionSettingsId,
      'user_id': userId,
      'total_production': totalProduction.toStringAsFixed(2),
      'type': type,
      'profit_ratio': profitRatio.toStringAsFixed(4),
      'notes': notes,
      'month': month,
      'year': year.toString(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
