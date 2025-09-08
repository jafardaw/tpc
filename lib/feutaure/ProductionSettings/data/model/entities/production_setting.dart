// lib/features/production_settings/domain/entities/production_setting.dart
import 'package:equatable/equatable.dart';

class ProductionSetting extends Equatable {
  final int productionSettingsId;
  final int userId;
  final double totalProduction;
  final String type;
  final double profitRatio;
  final String notes;
  final int month;
  final int year;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductionSetting({
    required this.productionSettingsId,
    required this.userId,
    required this.totalProduction,
    required this.type,
    required this.profitRatio,
    required this.notes,
    required this.month,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        productionSettingsId,
        userId,
        totalProduction,
        type,
        profitRatio,
        notes,
        month,
        year,
        createdAt,
        updatedAt,
      ];
}
