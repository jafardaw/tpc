class AddProductionSettingsModel {
  final double totalProduction;
  final String type; // "estimated" or "real"
  final double profitRatio;
  final int month;
  final int year;
  final String? notes; // Nullable as per your example

  AddProductionSettingsModel({
    required this.totalProduction,
    required this.type,
    required this.profitRatio,
    required this.month,
    required this.year,
    this.notes,
  });

  factory AddProductionSettingsModel.fromJson(Map<String, dynamic> json) {
    return AddProductionSettingsModel(
      totalProduction: (json['total_production'] as num).toDouble(),
      type: json['type'] as String,
      profitRatio: (json['profit_ratio'] as num).toDouble(),
      month: json['month'] as int,
      year: json['year'] as int,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_production': totalProduction,
      'type': type,
      'profit_ratio': profitRatio,
      'month': month,
      'year': year,
      'notes': notes,
    };
  }
}
