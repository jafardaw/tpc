import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/my_app_colors.dart';
import 'package:tcp212/constants/style.dart';
import 'package:tcp212/constants/validate.dart';
import 'package:tcp212/view_models/expences_cubit/expences_cubit.dart';
import 'package:tcp212/widgets/expenses_widget.dart/notes_field.dart';
import 'package:tcp212/widgets/expenses_widget.dart/ammount_field.dart';
import 'package:tcp212/widgets/expenses_widget.dart/custom_popup_menu.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? selectedCategory;
  String? selectedType;
  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpencesCubit()..fetchExpensesCategories(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "New Expense",
            style: AppTextStyles.calibri20SemiBoldBlack,
          ),
          backgroundColor: Color(0xff9AE3CE),
          centerTitle: true,
        ),
        body: BlocListener<ExpencesCubit, ExpencesState>(
          listener: (context, state) {
            if (state is ExpenseAddSuccess) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.rightSlide,
                btnOkColor: MyAppColors.kPrimary,
                title: 'Add Expense',
                desc: "Expenses Added Succefully",
                btnCancelOnPress: () {},
                btnOkOnPress: () {},
              ).show();
              // Clear form
              _amountController.clear();
              _notesController.clear();
              setState(() {
                selectedCategory = null;
                selectedType = null;
              });
            } else if (state is ExpenseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<ExpencesCubit, ExpencesState>(
            builder: (context, state) => Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 10.h),
                      child: Text(
                        "Category",
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.h),
                      child: FormField<String>(
                        validator: Validate.validateCategory,
                        builder: (FormFieldState<String> field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomPopupMenu(
                                menuItems: state is ExpenseCategoriesLoaded
                                    ? state.expensesCategories
                                          .map((category) => category.name)
                                          .toList()
                                    : ['Loading...'],
                                onSelected: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                  field.didChange(value);
                                },
                                selectedValue: selectedCategory,
                              ),
                              if (field.hasError)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 8.h,
                                    left: 12.w,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 10.h),
                      child: Text(
                        "Type",
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.h),
                      child: FormField<String>(
                        validator: Validate.validateType,
                        builder: (FormFieldState<String> field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomPopupMenu(
                                menuItems: ['real', 'estimated'],
                                onSelected: (value) {
                                  setState(() {
                                    selectedType = value;
                                  });
                                  field.didChange(value);
                                },
                                selectedValue: selectedType,
                              ),
                              if (field.hasError)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 8.h,
                                    left: 12.w,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 10.h),
                      child: Text(
                        "Amount",
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.h),
                      child: AmmountField(
                        hint: "Enter amount",
                        controller: _amountController,
                        validator: Validate.validateAmount,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 10.h),
                      child: Text(
                        "Notes",
                        style: AppTextStyles.calibri20SemiBoldBlack,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 12.h,
                        left: 12.w,
                        right: 12.w,
                        bottom: 25.h,
                      ),
                      child: NotesField(
                        hint: "Notes",
                        controller: _notesController,
                        validator: Validate.validateNotes,
                      ),
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: state is ExpenseLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  // Get category ID from selected category
                                  final categoryId =
                                      state is ExpenseCategoriesLoaded
                                      ? state.expensesCategories
                                            .firstWhere(
                                              (cat) =>
                                                  cat.name == selectedCategory,
                                              orElse: () => state
                                                  .expensesCategories
                                                  .first,
                                            )
                                            .expenseCategoryId
                                      : 1;

                                  context.read<ExpencesCubit>().createExpense(
                                    expenseCategoryId: categoryId,
                                    amount: double.parse(
                                      _amountController.text,
                                    ),
                                    type: selectedType ?? 'real',
                                    userId:
                                        1, // You might want to get this from user session
                                  );
                                }
                              },
                        color: Color(0xff9AE3CE),
                        height: 50.h,
                        minWidth: 300.w,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: state is ExpenseLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Add Expense",
                                style: AppTextStyles.calibri20SemiBoldBlack,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
