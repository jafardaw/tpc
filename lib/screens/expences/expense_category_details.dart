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
import 'package:tcp212/widgets/expenses_widget.dart/list_tile_of_category_details.dart';
import 'package:tcp212/widgets/expenses_widget.dart/notes_field.dart';

class ExpenseCategoryDetails extends StatelessWidget {
  final int id;
  const ExpenseCategoryDetails({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (_) => ExpencesCubit()..fetchOneCategory(id),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading:
                true, // Set to false if this is a root page
            title: 'Expense details',
          ),
        ),
        body: BlocBuilder<ExpencesCubit, ExpencesState>(
          builder: (context, state) {
            if (state is ExpenseCategoriesLoaded) {
              final expense = state.expensesCategories;
              return Column(
                children: [
                  ListTileOfCategoryDeatails(
                    name: expense[0].name,
                    description: expense[0].description,
                    created: expense[0].createdAt.toString(),
                    updated: expense[0].updatedAt.toString(),
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: () {
                      context.read<ExpencesCubit>().enableEditMode2(expense[0]);
                    },
                    child: Text(
                      "Edit category",
                      style: AppTextStyles.calibri24BoldPrimary,
                    ),
                  ),
                ],
              );
            } else if (state is ExpenseEditMode2) {
              final expense =
                  state.expense; // أو state.expenseCategory حسب اسم الخاصية
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTileOfCategoryDeatails(
                        name: expense.name,
                        description: expense.description,
                        created: expense.createdAt.toString(),
                        updated: expense.updatedAt.toString(),
                      ),
                      SizedBox(height: 5.h),
                      TextButton(
                        onPressed: () {
                          context.read<ExpencesCubit>().enableEditMode2(
                            expense,
                          );
                        },
                        child: Text(
                          "Edit expenses",
                          style: AppTextStyles.calibri24BoldPrimary,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: AmmountField(
                          hint: "New name",
                          validator: Validate.validateName,
                          controller: nameController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: NotesField(
                          hint: "New description",
                          controller: descController,
                          validator: Validate.validateNotes,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<ExpencesCubit>().updateCategory(
                              state.expense.expenseCategoryId,
                              nameController.text,
                              descController.text,
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
            } else if (state is ExpenseCategoryUpdated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.rightSlide,
                  title: 'Edit Category',
                  desc: 'Category Editing Successfully',
                  btnOkOnPress: () {
                    // إغلاق الـ Dialog يدويًا
                    Navigator.of(context, rootNavigator: true).pop();
                    // ثم التنقل
                    context.push(AppRoutes.expenseCategories);
                  },
                  btnCancelOnPress: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    context.push(AppRoutes.expenseCategories);
                  },
                ).show();
              });
              return Container();
            } else if (state is ExpenseError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
