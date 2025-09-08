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
import 'package:tcp212/widgets/expenses_widget.dart/ammount_field.dart';
import 'package:tcp212/widgets/expenses_widget.dart/notes_field.dart';

class AddExpenseCategore extends StatelessWidget {
  const AddExpenseCategore({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    return BlocProvider(
      create: (_) => ExpencesCubit()..fetchExpensesCategories(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading:
                true, // Set to false if this is a root page
            title: 'Add Expense Category',
          ),
        ),
        body: BlocListener<ExpencesCubit, ExpencesState>(
          listener: (context, state) {
            if (state is CategorisAddSuccess) {
              Fluttertoast.showToast(
                msg: "Expense Category Added Succecfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              nameController.clear();
              descController.clear();

              context.push(AppRoutes.expenseCategories);
            }
          },
          child: BlocBuilder<ExpencesCubit, ExpencesState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, top: 10.h),
                        child: Text(
                          "Category name",
                          style: AppTextStyles.calibri20SemiBoldBlack,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.h),
                        child: AmmountField(
                          hint: "category name",
                          validator: Validate.validateName,
                          controller: nameController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, top: 10.h),
                        child: Text(
                          "Description",
                          style: AppTextStyles.calibri20SemiBoldBlack,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.h),
                        child: NotesField(
                          hint: "description",
                          validator: Validate.validateDescription,
                          controller: descController,
                        ),
                      ),
                      SizedBox(height: 60.h),
                      Center(
                        child: MaterialButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            if (formKey.currentState!.validate()) {
                              context
                                  .read<ExpencesCubit>()
                                  .createExpenseCategory(
                                    name: nameController.text,
                                    description: descController.text,
                                  );
                            }
                          },
                          color: Color(0xff9AE3CE),
                          height: 50.h,
                          minWidth: 300.w,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            "Save",
                            style: AppTextStyles.calibri20SemiBoldBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
