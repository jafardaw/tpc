import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcp212/models/expenses_categories_model.dart';
import 'package:tcp212/models/expenses_model.dart';
import 'package:http/http.dart' as http;
part 'expences_state.dart';

class ExpencesCubit extends Cubit<ExpencesState> {
  ExpencesCubit() : super(ExpenseLoading());
  final String baseUrl = "http://127.0.0.1:8000/api";
  Future<void> fetchExpenses() async {
    emit(ExpenseLoading());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await http.get(Uri.parse('$baseUrl/expenses/'),
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        final expenses = data.map((e) => Expense.fromJson(e)).toList();
        emit(ExpenseLoaded(expenses));
      } else {
        emit(ExpenseError('فشل التحميل'));
      }
    } catch (e) {
      emit(ExpenseError('خطأ في الاتصال: $e'));
      log('خطأ في الاتصال: $e');
    }
  }

  Future<void> fetchExpensesCategories() async {
    emit(ExpensCategoriesLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.get(Uri.parse('$baseUrl/expense-categories/'),
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        final expensesCategories =
            data.map((e) => ExpenseCategory.fromJson(e)).toList();
        emit(ExpenseCategoriesLoaded(expensesCategories));
      } else {
        emit(ExpenseCategoriesError('فشل التحميل'));
      }
    } catch (e) {
      emit(ExpenseCategoriesError('خطأ في الاتصال: $e'));
    }
  }

  Future<void> createExpense({
    required int expenseCategoryId,
    required double amount,
    required String type,
    required int userId,
  }) async {
    emit(ExpenseLoading());
    try {
      log("Creating expense with: categoryId=$expenseCategoryId, amount=$amount, type=$type, userId=$userId");

      final requestBody = {
        'expense_category_id': expenseCategoryId,
        'amount': amount,
        'type': type,
        'user_id': userId,
      };

      log("Request body: ${jsonEncode(requestBody)}");

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.post(
        Uri.parse('$baseUrl/expenses'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      log("Response status: ${response.statusCode}");
      log("Response headers: ${response.headers}");
      log("Response body: ${response.body}");

      // Check for redirects
      if (response.statusCode == 301 || response.statusCode == 302) {
        log("Redirect detected - API endpoint may be incorrect");
        emit(ExpenseError(
            'API endpoint redirect detected. Please check the URL.'));
        return;
      }

      // Check if response is JSON
      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        log("Non-JSON response received. Content-Type: $contentType");
        emit(ExpenseError(
            'Server returned non-JSON response. Please check API endpoint.'));
        return;
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          log("Success response data: $responseData");

          if (responseData.containsKey('data')) {
            final data = responseData['data'];
            log("Success data: $data");
            emit(ExpenseAddSuccess(Expense.fromJson(data)));
          } else {
            log("No 'data' key in response");
            emit(ExpenseError('Invalid response format from server'));
          }
        } catch (e) {
          log("JSON parsing error: $e");
          emit(ExpenseError('Invalid JSON response from server'));
        }
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          log("Error response: $errorBody");
          final errorMessage =
              errorBody['message'] ?? errorBody['error'] ?? 'Unknown error';
          emit(ExpenseError('Failed to create expense: $errorMessage'));
        } catch (e) {
          log("Error parsing error response: $e");
          emit(ExpenseError(
              'Failed to create expense: HTTP ${response.statusCode}'));
        }
      }
    } catch (e) {
      log("Exception in createExpense: $e");
      emit(ExpenseError('Network error: $e'));
    }
  }

  Future<void> createExpenseCategory({
    required String name,
    required String description,
  }) async {
    emit(ExpenseLoading());
    try {
      log("Creating expense with:  name=$name, description=$description,");

      final requestBody = {
        'name': name,
        'description': description,
      };

      log("Request body: ${jsonEncode(requestBody)}");
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse('$baseUrl/expense-categories/'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      log("Response status: ${response.statusCode}");
      log("Response headers: ${response.headers}");
      log("Response body: ${response.body}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          log("Success response data: $responseData");

          if (responseData.containsKey('data')) {
            final data = responseData['data'];
            log("Success data: $data");
            emit(CategorisAddSuccess(ExpenseCategory.fromJson(data)));
          } else {
            log("No 'data' key in response");
            emit(ExpenseError('Invalid response format from server'));
          }
        } catch (e) {
          log("JSON parsing error: $e");
          emit(ExpenseError('Invalid JSON response from server'));
        }
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          log("Error response: $errorBody");
          final errorMessage =
              errorBody['message'] ?? errorBody['error'] ?? 'Unknown error';
          emit(ExpenseError('Failed to create expense: $errorMessage'));
        } catch (e) {
          log("Error parsing error response: $e");
          emit(ExpenseError(
              'Failed to create expense: HTTP ${response.statusCode}'));
        }
      }
    } catch (e) {
      log("Exception in createExpense: $e");
      emit(ExpenseError('Network error: $e'));
    }
  }

  Future<void> fetchExpense(int id) async {
    emit(ExpenseLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse('$baseUrl/expenses/$id'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      log("1");
      if (response.statusCode == 200 || response.statusCode == 200) {
        log("2");
        final jsonBody = json.decode(response.body);
        final expense = Expense.fromJson(jsonBody['data']);
        log("3");
        log(expense.toString());
        emit(Expense1Loaded(expense));
      } else {
        emit(ExpenseError('Failed to load expense'));
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> deleteExpense(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('DELETE', Uri.parse('$baseUrl/expenses/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> deleteExpenseCategory(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request =
        http.Request('DELETE', Uri.parse('$baseUrl/expense-categories/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> fetchExpensesByCategory(String name) async {
    emit(ExpenseLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.get(
          Uri.parse('$baseUrl/expenses/search?name=$name'),
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        final expenses = data.map((e) => Expense.fromJson(e)).toList();
        emit(ExpenseLoaded(expenses));
      } else {
        emit(ExpenseError('فشل التحميل'));
      }
    } catch (e) {
      emit(ExpenseError('خطأ في الاتصال: $e'));
      log('خطأ في الاتصال: $e');
    }
  }

  Future<void> fetchExpensesByMonth(String year, String month) async {
    emit(ExpenseLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse("$baseUrl/expenses/by-month?year=$year&month=$month"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      log("Response status: ${response.statusCode}");
      log("Response headers: ${response.headers}");
      log("Response body: ${response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        emit(ExpenseError(
            'Server returned non-JSON response. Please check API endpoint.'));
        return;
      }

      final json = jsonDecode(response.body);
      if (json['status'] == 200 && json['data'] != null) {
        final data = json['data'] as List;
        final expenses = data.map((e) => Expense.fromJson(e)).toList();
        log(expenses.toString());
        emit(FilterExpenseLoaded(expenses));
      } else {
        emit(ExpenseLoaded([]));
      }
    } catch (e) {
      print("Error loading monthly expenses: $e");
      emit(ExpenseLoaded([]));
    }
  }

  Future<void> updateExpense(int id, String amountText, String notes) async {
    emit(ExpenseLoading());

    final url = Uri.parse('$baseUrl/expenses/$id');
    final body = jsonEncode({
      'amount': amountText,
      'notes': notes,
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.put(url,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final data = body['data'] as Map<String, dynamic>;
        final updatedExpense = Expense.fromJson(data);

        emit(ExpenseUpdated(updatedExpense));
      } else {
        emit(ExpenseError(
          'خطأ في الخادم (status: ${response.statusCode})',
        ));
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> fetchOneCategory(int id) async {
    emit(ExpenseLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse('$baseUrl/expense-categories/$id'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      log("1");
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("2");
        final jsonBody = json.decode(response.body);
        final expense = ExpenseCategory.fromJson(jsonBody['data']);
        log("3");
        log(expense.toString());
        emit(ExpenseCategoriesLoaded([expense]));
      } else {
        emit(ExpenseError('Failed to load expense'));
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> updateCategory(int id, String name, String description) async {
    emit(ExpenseLoading());

    final url = Uri.parse('$baseUrl/expense-categories/$id');
    final body = jsonEncode({
      'name': name,
      'description': description,
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final data = body['data'] as Map<String, dynamic>;
        final updatedCategory = ExpenseCategory.fromJson(data);
        emit(ExpenseCategoryUpdated(updatedCategory));
      } else {
        emit(ExpenseError(
          'خطأ في الخادم (status: ${response.statusCode})',
        ));
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  void enableEditMode(Expense expense) {
    emit(ExpenseEditMode(expense));
  }

  void enableEditMode2(ExpenseCategory expense) {
    emit(ExpenseEditMode2(expense));
  }
}
