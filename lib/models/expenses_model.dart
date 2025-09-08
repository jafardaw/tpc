class Expense {
  final int id;
  final int userId;
  final int categoryId;
  final String type;
  final double amount;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expense({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['expense_id'],
        userId: json['user_id'],
        categoryId: json['expense_category_id'],
        type: json['type'] ?? 'real',
        amount: json['amount'] is int ? (json['amount'] as int).toDouble() : double.parse(json['amount'].toString()),
        notes: json['notes'] ?? '',
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  @override
  String toString() {
    return 'Expense(id: $id, amount: $amount, type: $type, notes: $notes)';
  }
}