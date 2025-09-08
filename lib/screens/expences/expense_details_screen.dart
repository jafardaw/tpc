import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tcp212/constants/style.dart';
import 'package:tcp212/constants/validate.dart';
import 'package:tcp212/core/util/app_router.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/view_models/expences_cubit/expences_cubit.dart';
import 'package:tcp212/widgets/expenses_widget.dart/ammount_field.dart';
import 'package:tcp212/widgets/expenses_widget.dart/list_tile_of_deatails.dart';
import 'package:tcp212/widgets/expenses_widget.dart/notes_field.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final int expensId;
  const ExpenseDetailsScreen({super.key, required this.expensId});

  @override
  Widget build(BuildContext context) {
    TextEditingController ammountController = TextEditingController();
    TextEditingController notesController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (_) => ExpencesCubit()..fetchExpense(expensId),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading:
                true, // Set to false if this is a root page
            title: 'Expenses Categories',
          ),
        ),
        body: BlocBuilder<ExpencesCubit, ExpencesState>(
          builder: (context, state) {
            if (state is Expense1Loaded) {
              final expense = state.expense;
              return Column(
                children: [
                  ListTileOfDeatails(
                    ammount: expense.amount.toString(),
                    type: expense.type,
                    notes: expense.notes,
                    created: expense.createdAt.toString(),
                    updated: expense.updatedAt.toString(),
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: () {
                      context.read<ExpencesCubit>().enableEditMode(expense);
                    },
                    child: Text(
                      "Edit expenses",
                      style: AppTextStyles.calibri24BoldPrimary,
                    ),
                  ),
                ],
              );
            } else if (state is ExpenseEditMode) {
              final expense = state.expense;
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTileOfDeatails(
                        ammount: expense.amount.toString(),
                        type: expense.type,
                        notes: expense.notes,
                        created: expense.createdAt.toString(),
                        updated: expense.updatedAt.toString(),
                      ),
                      SizedBox(height: 5.h),
                      TextButton(
                        onPressed: () {
                          context.read<ExpencesCubit>().enableEditMode(expense);
                        },
                        child: Text(
                          "Edit expenses",
                          style: AppTextStyles.calibri24BoldPrimary,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: AmmountField(
                          hint: "New Ammount",
                          validator: Validate.validateAmount,
                          controller: ammountController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: NotesField(
                          hint: "Notes",
                          controller: notesController,
                          validator: Validate.validateNotes,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            log(state.toString());
                            context.read<ExpencesCubit>().updateExpense(
                              state.expense.id,
                              ammountController.text,
                              notesController.text,
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
                          "save",
                          style: AppTextStyles.calibri20SemiBoldBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ExpenseUpdated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.rightSlide,
                  title: 'Edit Expense',
                  desc: 'Expense Editing Successfully',
                  btnOkOnPress: () {
                    // إغلاق الـ Dialog يدويًا
                    Navigator.of(context, rootNavigator: true).pop();
                    // ثم التنقل
                    context.push(AppRoutes.expenses);
                  },
                  btnCancelOnPress: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    context.push(AppRoutes.expenses);
                  },
                ).show();
              });
              return Container();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
