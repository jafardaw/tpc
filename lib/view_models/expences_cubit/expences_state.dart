part of 'expences_cubit.dart';

abstract class ExpencesState {}

class ExpenseLoading extends ExpencesState {}

class ExpenseLoaded extends ExpencesState {
  final List<Expense> expenses;
  ExpenseLoaded(this.expenses);
}

class ExpenseError extends ExpencesState {
  final String message;
  ExpenseError(this.message);
}

class ExpensCategoriesLoading extends ExpencesState {}

class ExpenseCategoriesLoaded extends ExpencesState {
  final List<ExpenseCategory> expensesCategories;
  ExpenseCategoriesLoaded(this.expensesCategories);
}

class ExpenseCategoriesError extends ExpencesState {
  final String message;
  ExpenseCategoriesError(this.message);
}

class ExpenseAddSuccess extends ExpencesState {
  final Expense expense;
  ExpenseAddSuccess(this.expense);
}

//***********************fetch expense by id************************ */

class Expense1Loaded extends ExpencesState {
  final Expense expense;
  Expense1Loaded(this.expense);
}
/************************filter expenses***************** */

class FilterExpenseLoaded extends ExpencesState {
  final List<Expense> expenses;
  FilterExpenseLoaded(this.expenses);
}

/***************************** */
class ExpenseUpdated extends ExpencesState {
  final Expense expenses;
  ExpenseUpdated(this.expenses);
}

/*************************** */
class ExpenseEditMode extends ExpencesState {
  final Expense expense;
  ExpenseEditMode(this.expense);
}

class ExpenseEditMode2 extends ExpencesState {
  final ExpenseCategory expense;
  ExpenseEditMode2(this.expense);
}

class ExpenseCategoryUpdated extends ExpencesState {
  final ExpenseCategory category;
  ExpenseCategoryUpdated(this.category);
}

class CategorisAddSuccess extends ExpencesState {
  final ExpenseCategory expense;
  CategorisAddSuccess(this.expense);
}
