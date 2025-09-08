import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/alert_dilog.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/custom_button.dart';
import 'package:tcp212/core/widget/custom_field.dart';
import 'package:tcp212/feutaure/allUsers/data/model/user_model.dart';
import 'package:tcp212/feutaure/allUsers/presentation/manger/cubit/user_cubit.dart';
import 'package:tcp212/feutaure/allUsers/presentation/manger/cubit/user_state.dart';
import 'package:tcp212/feutaure/allUsers/repo/user_repo.dart';

class EditUserScreen extends StatefulWidget {
  final int userId; // ID of the user to edit
  final UserModel currentUser; // Current user data to pre-fill fields

  const EditUserScreen({
    super.key,
    required this.userId,
    required this.currentUser,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late String _selectedRole;
  late bool _isActive;

  late UsersCubit _usersCubit;

  final List<String> _userRoles = [
    'admin', // أضف admin هنا لتجنب خطأ إذا كان المستخدم الحالي admin
    'accountant',
    'warehouse_keeper',
    // يمكن إضافة أدوار أخرى إذا كانت موجودة
  ]; // Available roles

  @override
  void initState() {
    super.initState();
    _usersCubit = UsersCubit(repository: UserRepoImpl(ApiService()));

    _nameController = TextEditingController(text: widget.currentUser.name);
    _emailController = TextEditingController(text: widget.currentUser.email);
    _phoneController = TextEditingController(text: widget.currentUser.phone);
    _selectedRole = widget.currentUser.userRole;
    _isActive = widget.currentUser.flag == 1; // Convert 0/1 to bool
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usersCubit.close(); // Close the cubit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Edit User: ${widget.currentUser.name}',
        ),
      ),
      body: BlocProvider<UsersCubit>.value(
        value: _usersCubit, // Provide the same cubit instance
        child: BlocConsumer<UsersCubit, UsersState>(
          listener: (context, state) {
            if (state is UserUpdated) {
              showCustomSnackBar(
                context,
                state.message,
                color: Palette.primarySuccess,
              );

              Navigator.pop(context, true); // Return with update success signal
            } else if (state is UserUpdateFailed) {
              showCustomAlertDialog(
                context: context,
                title: 'Sorry! 😢',
                content: 'Failed to update user: ${state.errorMessage}',
              );
            }
          },
          builder: (context, state) {
            // If fetching user data (if you enabled fetchUserById)
            if (state is UserUpdating && state.userId == widget.userId) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2.0),
              );
            }
            // Show the form after loading data or in initial state
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit User Details:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      controller: _nameController,
                      label: Text('Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _emailController,
                      label: Text('Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _phoneController,
                      label: Text('Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: inputDecoration('User Role', Icons.category),
                      items: _userRoles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select user role';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      title: const Text(
                        'Account Active',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: _isActive,
                      onChanged: (bool newValue) {
                        setState(() {
                          _isActive = newValue;
                        });
                      },
                      activeThumbColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: "Save Changes",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _usersCubit.updateUser(
                            userId: widget.userId,
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            userRole: _selectedRole,
                            flag: _isActive,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper function to create consistent Input Decoration
  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      prefixIcon: Icon(icon, color: Colors.blueGrey.shade700),
      filled: true,
      fillColor: Colors.blueGrey.shade50,
    );
  }
}
