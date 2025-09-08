import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tcp212/core/util/app_router.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/view_models/expences_cubit/expences_cubit.dart';
import 'package:tcp212/widgets/expenses_widget.dart/expenses_list_tile.dart';

class ExpensesByCategory extends StatelessWidget {
  final String categoryName;
  const ExpensesByCategory({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpencesCubit()..fetchExpensesByCategory(categoryName),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading:
                true, // Set to false if this is a root page
            title: categoryName,
          ),
        ),
        body: BlocBuilder<ExpencesCubit, ExpencesState>(
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExpenseLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      itemCount: state.expenses.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final expense = state.expenses[index];
                        return Dismissible(
                          key: Key(expense.id.toString()),
                          direction: DismissDirection
                              .startToEnd, // أو startToEnd حسب الاتجاه
                          onDismissed: (direction) {
                            context.read<ExpencesCubit>().deleteExpense(
                              expense.id,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم حذف العنصر')),
                            );
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
                                pathParameters: {
                                  'expens_id': expense.id.toString(),
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is ExpenseError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
