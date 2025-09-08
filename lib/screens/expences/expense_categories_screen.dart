import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:tcp212/constants/my_app_colors.dart';
import 'package:tcp212/constants/my_app_icons.dart';
import 'package:tcp212/core/util/app_router.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/view_models/expences_cubit/expences_cubit.dart';
import 'package:tcp212/widgets/expenses_widget.dart/expenses_categories_list_tile.dart';

class ExpenseCategoriesScreen extends StatefulWidget {
  const ExpenseCategoriesScreen({super.key});

  @override
  State<ExpenseCategoriesScreen> createState() =>
      _ExpenseCategoriesScreenState();
}

class _ExpenseCategoriesScreenState extends State<ExpenseCategoriesScreen> {
  List<dynamic> _categories = [];
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpencesCubit()..fetchExpensesCategories(),
      child: Scaffold(
        appBar:
            // AppBar(
            //   actions: [
            //     IconButton(
            //         onPressed: () {
            //           final searchDelegate = DataSearch();
            //           searchDelegate.allCategories = _categories;
            //           showSearch(context: context, delegate: searchDelegate);
            //         },
            //         icon: Icon(
            //           Icons.search,
            //           size: 25.sp,
            //           color: Colors.black,
            //         ))
            //   ],
            //   title: const Text(
            //     'Expenses Categories',
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            //   centerTitle: true,
            //   backgroundColor: Color(0xff9AE3CE),
            // ),
            PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppareWidget(
                actions: [
                  IconButton(
                    onPressed: () {
                      final searchDelegate = DataSearch();
                      searchDelegate.allCategories = _categories;
                      showSearch(context: context, delegate: searchDelegate);
                    },
                    icon: Icon(Icons.search, size: 25.sp),
                  ),
                ],
                automaticallyImplyLeading:
                    true, // Set to false if this is a root page
                title: 'Expenses Categories',
              ),
            ),
        body: BlocBuilder<ExpencesCubit, ExpencesState>(
          builder: (context, state) {
            if (state is ExpensCategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExpenseCategoriesLoaded) {
              // Initialize local list only once
              if (!_initialized) {
                _categories = List.from(state.expensesCategories);
                _initialized = true;
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      itemCount: _categories.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final expense = _categories[index];
                        return Dismissible(
                          key: Key(expense.expenseCategoryId.toString()),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            setState(() {
                              _categories.removeAt(index);
                            });
                            context.read<ExpencesCubit>().deleteExpenseCategory(
                              expense.expenseCategoryId,
                            );
                            Fluttertoast.showToast(
                              msg: "Expense Category  deleted Succecfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: ExpensesCategoriesListTile(
                            name: expense.name,
                            description: expense.description,
                            onPressed: () {
                              context.pushNamed(
                                AppRoutes.expensesByCategory,
                                queryParameters: {
                                  'categoryName': '${expense.name}',
                                },
                              );
                            },
                            onPressed2: () {
                              context.pushNamed(
                                AppRoutes.expenseCategoryDetails,
                                queryParameters: {
                                  'id': expense.expenseCategoryId.toString(),
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
            } else if (state is ExpenseCategoriesError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(AppRoutes.addExpenseCategory);
          },
          backgroundColor: Color(0xff9AE3CE),
          child: Icon(Icons.add, size: 30.sp, color: Colors.black),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class DataSearch extends SearchDelegate {
  List<dynamic> allCategories = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    // Filter categories based on query
    List<dynamic> filteredCategories = allCategories.where((category) {
      return category.name.toLowerCase().contains(query.toLowerCase()) ||
          category.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filteredCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'there is no result for  "$query"',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: MyAppColors.getCategoryColor(category.name),
              child: Icon(
                MyAppIcons.getCategoryIcon(category.name),
                color: Colors.white,
              ),
            ),
            title: Text(
              category.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(category.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // Navigate to category details
                    context.pushNamed(
                      AppRoutes.expenseCategoryDetails,
                      queryParameters: {
                        'id': category.expenseCategoryId.toString(),
                      },
                    );
                  },
                  icon: Icon(Icons.info, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to expenses by category
                    context.pushNamed(
                      AppRoutes.expensesByCategory,
                      queryParameters: {'categoryName': category.name},
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                ),
              ],
            ),
            onTap: () {
              // Navigate to expenses by category on tap
              context.pushNamed(
                AppRoutes.expensesByCategory,
                queryParameters: {'categoryName': category.name},
              );
            },
          ),
        );
      },
    );
  }
}
