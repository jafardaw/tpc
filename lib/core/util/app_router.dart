import 'package:go_router/go_router.dart';
import 'package:tcp212/screens/auth/on_boarding_screen.dart';
import 'package:tcp212/screens/auth/register_screen.dart';
import 'package:tcp212/screens/auth/sign_in_screen.dart';
import 'package:tcp212/screens/auth/splash_screen.dart';
import 'package:tcp212/screens/expences/add_expense.dart';
import 'package:tcp212/screens/expences/add_expense_categore.dart';
import 'package:tcp212/screens/expences/expense_categories_screen.dart';
import 'package:tcp212/screens/expences/expense_category_details.dart';
import 'package:tcp212/screens/expences/expense_details_screen.dart';
import 'package:tcp212/screens/expences/expenses_by_category.dart';
import 'package:tcp212/screens/expences/expenses_screen.dart';
import 'package:tcp212/screens/expences/filtered_expenses.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/screens/product_sales/add_product_sale_screen.dart';
import 'package:tcp212/screens/product_sales/product_sales_screen.dart';
import 'package:tcp212/screens/product_sales/sales_details.dart';
import 'package:tcp212/view_models/expences_cubit/expences_cubit.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onBoarding = '/on_boarding_screen';
  static const String register = '/register_screen';
  static const String signIn = '/sign_in_screen';
  static const String home = '/home_screen';
  static const String expenses = '/expenses_screen';
  static const String addExpense = '/add_expense';
  static const String expenseCategories = '/expense_categories_screen';
  static const String addExpenseCategory = '/add_expense_category';
  static const String expenseDeatails = '/expense_details_screen/:expens_id';
  static const String expensesByCategory = '/expenses_by_category';
  static const String filteredExpenses = '/filtered_expenses';
  static const String expenseCategoryDetails = '/expense_category_details';
  static const String productSales = '/product_sales_screen';
  static const String salesDetails = '/sales_details';
  static const String AddProductSalesScreen = '/add_product_sale_screen';
}

GoRouter router = GoRouter(
  // initialLocation: AppRoutes.productSale
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => SplashSreen(),
    ),
    GoRoute(
      path: AppRoutes.onBoarding,
      name: AppRoutes.onBoarding,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.register,
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      name: AppRoutes.signIn,
      builder: (context, state) => SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.expenses,
      name: AppRoutes.expenses,
      builder: (context, state) => ExpenseScreen(),
    ),
    GoRoute(
      path: AppRoutes.addExpense,
      name: AppRoutes.addExpense,
      builder: (context, state) => AddExpense(),
    ),
    GoRoute(
      path: AppRoutes.expenseCategories,
      name: AppRoutes.expenseCategories,
      builder: (context, state) => ExpenseCategoriesScreen(),
    ),
    GoRoute(
      path: AppRoutes.addExpenseCategory,
      name: AppRoutes.addExpenseCategory,
      builder: (context, state) => AddExpenseCategore(),
    ),
    GoRoute(
      path: AppRoutes.expenseDeatails,
      name: AppRoutes.expenseDeatails,
      builder: (context, state) => BlocProvider(
        create: (_) =>
            ExpencesCubit()
              ..fetchExpense(int.parse(state.pathParameters['expens_id']!)),
        child: ExpenseDetailsScreen(
          expensId: int.parse(state.pathParameters['expens_id']!),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.expensesByCategory,
      name: AppRoutes.expensesByCategory,
      builder: (context, state) => ExpensesByCategory(
        categoryName: state.uri.queryParameters['categoryName'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.filteredExpenses,
      name: AppRoutes.filteredExpenses,
      builder: (context, state) => FilteredExpenses(
        year: state.uri.queryParameters['year'] ?? '0',
        month: state.uri.queryParameters['month'] ?? '0',
      ),
    ),
    GoRoute(
      path: AppRoutes.expenseCategoryDetails,
      name: AppRoutes
          .expenseCategoryDetails, // <-- This is the name you should use
      builder: (context, state) => ExpenseCategoryDetails(
        id: int.parse(state.uri.queryParameters['id']!),
      ),
    ),
    GoRoute(
      path: AppRoutes.productSales,
      name: AppRoutes.productSales,
      builder: (context, state) => ProductSalesScreen(),
    ),
    GoRoute(
      path: AppRoutes.salesDetails,
      name: AppRoutes.salesDetails,
      builder: (context, state) =>
          SalesDetails(id: int.parse(state.uri.queryParameters['id']!)),
    ),
    GoRoute(
      path: AppRoutes.AddProductSalesScreen,
      name: AppRoutes.AddProductSalesScreen,
      builder: (context, state) => AddProductSaleScreen(),
    ),
  ],
);
