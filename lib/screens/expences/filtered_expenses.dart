import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tcp212/core/util/app_router.dart';
import 'package:tcp212/view_models/expences_cubit/expences_cubit.dart';
import 'package:tcp212/widgets/expenses_widget.dart/expenses_list_tile.dart';

class FilteredExpenses extends StatelessWidget {
  final String year;
  final String month;
  const FilteredExpenses({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpencesCubit()..fetchExpensesByMonth(year, month),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.push(AppRoutes.expenses);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            "$year,$month",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff9AE3CE),
        ),
        body: BlocBuilder<ExpencesCubit, ExpencesState>(
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FilterExpenseLoaded) {
              return ListView.builder(
                itemCount: state.expenses.length,
                itemBuilder: (context, index) {
                  final expense = state.expenses[index];
                  return Dismissible(
                    key: Key(expense.id.toString()),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      context.read<ExpencesCubit>().deleteExpense(expense.id);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('تم حذف العنصر')));
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ExpensesListTile(
                      ammount: expense.amount,
                      type: expense.type,
                      onPressed: () {
                        log(state.toString());
                        context.pushNamed(
                          AppRoutes.expenseDeatails,
                          pathParameters: {'expens_id': expense.id.toString()},
                        );
                      },
                    ),
                  );
                },
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
