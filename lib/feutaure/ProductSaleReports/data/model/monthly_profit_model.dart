class MonthlyProfitModel {
  final String month;
  final double totalProfit;

  MonthlyProfitModel({
    required this.month,
    required this.totalProfit,
  });

  factory MonthlyProfitModel.fromJson(Map<String, dynamic> json) {
    return MonthlyProfitModel(
      month: json['month'] as String,
      totalProfit: double.tryParse(json['total_profit'].toString()) ?? 0.0,
    );
  }
}
