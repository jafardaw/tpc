import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/const.dart';
import 'package:tcp212/core/util/func/alert_dilog.dart';
import 'package:tcp212/core/util/func/show.dart';
import 'package:tcp212/core/util/styles.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/cusrom_button_card.dart';
import 'package:tcp212/core/widget/custom_button.dart';
import 'package:tcp212/core/widget/empty_widget_view.dart';
import 'package:tcp212/core/widget/error_widget_view.dart';
import 'package:tcp212/feutaure/allUsers/data/model/user_model.dart';
import 'package:tcp212/feutaure/allUsers/presentation/manger/cubit/user_cubit.dart';
import 'package:tcp212/feutaure/allUsers/presentation/manger/cubit/user_state.dart';
import 'package:tcp212/feutaure/allUsers/presentation/view/edit_user_screen.dart';
import 'package:tcp212/feutaure/allUsers/presentation/view/profile_screen.dart';
import 'package:tcp212/feutaure/allUsers/repo/user_repo.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late UsersCubit _usersCubit;

  @override
  void initState() {
    super.initState();
    _usersCubit = UsersCubit(repository: UserRepoImpl(ApiService()));
    _usersCubit.fetchAllUsers();
  }

  @override
  void dispose() {
    _usersCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'All Users',
        ),
      ),
      body: BlocProvider<UsersCubit>.value(
        value: _usersCubit,
        child: BlocConsumer<UsersCubit, UsersState>(
          listener: (context, state) {
            if (state is UsersError) {
              showCustomAlertDialog(
                context: context,
                title: 'Sorry! 😢',
                content: state.errorMessage,
              );
            } else if (state is UserActivationChanged) {
              showCustomSnackBar(
                context,
                state.message,
                color: Palette.primarySuccess,
              );
            } else if (state is UserActivationChangeFailed) {
              showCustomAlertDialog(
                context: context,
                title: 'Sorry! 😢',
                content:
                    'Failed to change user activation status: ${state.errorMessage}',
              );
            } else if (state is UserUpdated) {
              showCustomSnackBar(
                context,
                state.message,
                color: Palette.primarySuccess,
              );
            } else if (state is UserUpdateFailed) {
              showCustomAlertDialog(
                context: context,
                title: 'Sorry! 😢',
                content: 'Failed to update user: ${state.errorMessage}',
              );
            }
          },
          builder: (context, state) {
            if (state is UsersInitial ||
                state is UsersLoading ||
                state is UserActivationChanging) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2.0),
              );
            } else if (state is UsersLoaded) {
              if (state.users.isEmpty) {
                return const EmptyWigetView(
                  message: 'No users to display.',
                  icon: Icons.people_outline,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  final bool isChangingActivation =
                      context.watch<UsersCubit>().state
                          is UserActivationChanging &&
                      (context.watch<UsersCubit>().state
                                  as UserActivationChanging)
                              .userId ==
                          user.id;
                  final bool isUpdatingUser =
                      context.watch<UsersCubit>().state is UserUpdating &&
                      (context.watch<UsersCubit>().state as UserUpdating)
                              .userId ==
                          user.id;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getRoleColor(user.userRole),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  user.userRole.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1),
                          _buildUserInfoRow(Icons.email, 'Email:', user.email),
                          _buildUserInfoRow(Icons.phone, 'Phone:', user.phone),
                          Row(
                            children: [
                              Expanded(
                                child: _buildUserInfoRow(
                                  Icons.check_circle_outline,
                                  'Status:',
                                  user.flag == 1 ? 'Active' : 'Inactive',
                                  color: user.flag == 1
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                              ),
                              if (isChangingActivation) ...[
                                const SizedBox(width: 8.0),
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ] else
                                Switch(
                                  value: user.flag == 1,
                                  onChanged: (bool newValue) {
                                    _confirmChangeActivation(
                                      context,
                                      user.id,
                                      user.name,
                                      newValue,
                                    );
                                  },
                                  hoverColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                  inactiveTrackColor: Colors.red.shade100,
                                ),
                            ],
                          ),
                          if (user.fcmToken != null &&
                              user.fcmToken!.isNotEmpty)
                            _buildUserInfoRow(
                              Icons.notifications_active,
                              'FCM Token:',
                              user.fcmToken!,
                            ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Created at: ${user.createdAt.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Last updated: ${user.updatedAt.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: ButtonINCard(
                              icon: Text(
                                isUpdatingUser ? 'Updating...' : 'Update',
                                style: Styles.textStyle18.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              label: isUpdatingUser
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                isUpdatingUser
                                    ? null
                                    : () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (c) => EditUserScreen(
                                              userId: user.id,
                                              currentUser: user,
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          _usersCubit.fetchAllUsers();
                                        }
                                      };
                              },
                            ),
                          ),
                          const SizedBox(height: 17),
                          Center(
                            child: ButtonINCard(
                              label: Icon(Icons.edit, color: Colors.white),
                              icon: Text(
                                'Profile',
                                style: Styles.textStyle18.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      userId: state.users[index].id,
                                      userModel: state.users[index],
                                    ), // هنا ID المستخدم المراد عرض بروفايله
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is UsersError) {
              return Center(
                child: ErrorWidetView(
                  message: 'Error loading users: ${state.errorMessage}',
                  onPressed: () {
                    _usersCubit.fetchAllUsers();
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(
    IconData icon,
    String title,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? Colors.blueGrey.shade700),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: color ?? Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmChangeActivation(
    BuildContext context,
    int userId,
    String userName,
    bool willBeActive,
  ) async {
    final String action = willBeActive ? 'activate' : 'deactivate';
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm $action account'),
          content: Text(
            'Are you sure you want to $action "$userName" account?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: willBeActive ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(action.toUpperCase()),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // ignore: use_build_context_synchronously
      context.read<UsersCubit>().changeUserActivationStatus(userId);
    }
  }
}
