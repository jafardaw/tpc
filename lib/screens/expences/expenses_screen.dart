import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:tcp212/constants/style.dart';
import 'package:tcp212/constants/validate.dart';
import 'package:tcp212/core/util/app_router.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/view_models/expences_cubit/expences_cubit.dart';
import 'package:tcp212/widgets/expenses_widget.dart/expenses_list_tile.dart';
import 'package:tcp212/widgets/expenses_widget.dart/search_bar_widget.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController yearController = TextEditingController();
    TextEditingController monthController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (_) => ExpencesCubit()..fetchExpenses(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading:
                true, // Set to false if this is a root page
            title: 'Expences',
          ),
        ),
        body: BlocBuilder<ExpencesCubit, ExpencesState>(
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExpenseLoaded) {
              return Form(
                key: formKey,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0.h),
                            child: Text(
                              "Filter",
                              style: AppTextStyles.calibri20SemiBoldBlack,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              "Year",
                              style: AppTextStyles.calibri20SemiBoldBlack,
                            ),
                          ),
                          SearchBarWidget(
                            controller: yearController,
                            hint: "year",
                            validator: Validate.validateYear,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              "Month",
                              style: AppTextStyles.calibri20SemiBoldBlack,
                            ),
                          ),
                          SearchBarWidget(
                            controller: monthController,
                            hint: "month",
                            validator: Validate.validateMonth,
                          ),
                          Center(
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.pushNamed(
                                    AppRoutes.filteredExpenses,
                                    queryParameters: {
                                      'year': yearController.text,
                                      'month': monthController.text,
                                    },
                                  );
                                  context
                                      .read<ExpencesCubit>()
                                      .fetchExpensesByMonth(
                                        yearController.text,
                                        monthController.text,
                                      );
                                }
                              },
                              color: Color(0xff9AE3CE),
                              height: 40.h,
                              minWidth: 200.w,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                "Filter",
                                style: AppTextStyles.calibri20SemiBoldBlack,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final expense = state.expenses[index];
                        return Dismissible(
                          key: Key(expense.id.toString()),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            context.read<ExpencesCubit>().deleteExpense(
                              expense.id,
                            );
                            Fluttertoast.showToast(
                              msg: "Expense  deleted Succecfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0.sp,
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
                      }, childCount: state.expenses.length),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(AppRoutes.addExpense);
          },
          backgroundColor: Color(0xff9AE3CE),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
