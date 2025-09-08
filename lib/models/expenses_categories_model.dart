class ExpenseCategory {
  final int expenseCategoryId;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExpenseCategory({
    required this.expenseCategoryId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      expenseCategoryId: json['expense_category_id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expense_category_id': expenseCategoryId,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}