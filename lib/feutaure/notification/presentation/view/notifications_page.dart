// // lib/feutaure/notification/presentation/pages/notifications_page.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:tcp212/core/util/apiservice.dart';
// import 'package:tcp212/core/widget/appar_widget,.dart';
// import 'package:tcp212/feutaure/notification/data/model/notification_data_model.dart';

// import 'package:tcp212/feutaure/notification/presentation/manger/notifications_cubit.dart';
// import 'package:tcp212/feutaure/notification/presentation/manger/notifications_state.dart';
// import 'package:tcp212/feutaure/notification/repo/notifications_repo_impl.dart';

// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) {
//         final apiService = ApiService();
//         final notificationsRepo = NotificationsRepoImpl(apiService);
//         return NotificationsCubit(notificationsRepo)..fetchNotifications();
//       },
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(kToolbarHeight),
//           child: AppareWidget(
//             automaticallyImplyLeading: true,
//             title: 'الإشعارات',
//           ),
//         ),
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFFF0F4F8),
//                 Color(0xFFE8EEF4)
//               ], // Light, modern gradient
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: BlocBuilder<NotificationsCubit, NotificationsState>(
//             builder: (context, state) {
//               if (state is NotificationsLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is NotificationsFailure) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       'خطأ: ${state.errorMessage}',
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 );
//               } else if (state is NotificationsSuccess) {
//                 if (state.notifications.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'لا توجد إشعارات حالياً. ✨',
//                       style: TextStyle(fontSize: 18, color: Colors.blueGrey),
//                     ),
//                   );
//                 }
//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8.0, vertical: 12.0),
//                   itemCount: state.notifications.length,
//                   itemBuilder: (context, index) {
//                     final notification = state.notifications[index];
//                     return NotificationCard(notification: notification);
//                   },
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NotificationCard extends StatelessWidget {
//   final NotificationModel notification;

//   const NotificationCard({required this.notification, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isRead = notification.isRead;
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       decoration: BoxDecoration(
//         color: isRead ? Colors.white : Colors.lightBlue.shade50,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             offset: const Offset(0, 4),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             // Add functionality to handle notification click
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       notification.type == 'raw_material'
//                           ? Icons.inventory_2_outlined
//                           : Icons.production_quantity_limits_outlined,
//                       color: isRead
//                           ? Colors.blueGrey.shade300
//                           : Colors.blue.shade600,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Text(
//                         notification.title,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: isRead ? Colors.grey.shade600 : Colors.black87,
//                         ),
//                       ),
//                     ),
//                     if (!isRead)
//                       Container(
//                         width: 10,
//                         height: 10,
//                         decoration: BoxDecoration(
//                           color: Colors.redAccent,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 2),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   notification.message,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: isRead ? Colors.blueGrey.shade400 : Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildInfoChip(
//                       icon: Icons.storage_outlined,
//                       label: 'المخزون: ${notification.stock}',
//                       color:
//                           isRead ? Colors.grey.shade400 : Colors.teal.shade400,
//                     ),
//                     _buildInfoChip(
//                       icon: Icons.warning_amber_outlined,
//                       label: 'الحد الأدنى: ${notification.minimum}',
//                       color: isRead
//                           ? Colors.grey.shade400
//                           : Colors.orange.shade400,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     DateFormat('yyyy-MM-dd hh:mm a')
//                         .format(notification.createdAt),
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.blueGrey.shade300,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoChip(
//       {required IconData icon, required String label, required Color color}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(fontSize: 12, color: color),
//           ),
//         ],
//       ),
//     );
//   }
// }
// lib/feutaure/notification/presentation/pages/notifications_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/empty_widget_view.dart';
import 'package:tcp212/core/widget/error_widget_view.dart';
import 'package:tcp212/feutaure/notification/data/model/notification_data_model.dart';

import 'package:tcp212/feutaure/notification/presentation/manger/notifications_cubit.dart';
import 'package:tcp212/feutaure/notification/presentation/manger/notifications_state.dart';
import 'package:tcp212/feutaure/notification/repo/notifications_repo_impl.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final apiService = ApiService();
        final notificationsRepo = NotificationsRepoImpl(apiService);
        return NotificationsCubit(notificationsRepo)..fetchNotifications();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'الإشعارات',
            actions: [
              BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsSuccess &&
                      state.notifications.isNotEmpty) {
                    return TextButton(
                      onPressed: () {
                        BlocProvider.of<NotificationsCubit>(
                          context,
                        ).markAllNotificationsAsReadAndRefresh();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'قراءة الكل',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF0F4F8), Color(0xFFE8EEF4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NotificationsFailure) {
                return ErrorWidetView(message: state.errorMessage);
              } else if (state is NotificationsSuccess) {
                if (state.notifications.isEmpty) {
                  return EmptyWigetView(
                    message: 'لا توجد إشعارات حالياً. ✨',
                    icon: Icons.notification_important_rounded,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 12.0,
                  ),
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return NotificationCard(notification: notification);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({required this.notification, super.key});

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // قم بقراءة الإشعار فقط إذا لم يكن مقروءاً بالفعل
            if (!isRead) {
              BlocProvider.of<NotificationsCubit>(
                context,
              ).markNotificationAsReadAndRefresh(notification.id);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      notification.type == 'raw_material'
                          ? Icons.inventory_2_outlined
                          : Icons.production_quantity_limits_outlined,
                      color: isRead
                          ? Colors.blueGrey.shade300
                          : Colors.blue.shade600,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isRead ? Colors.grey.shade600 : Colors.black87,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: isRead ? Colors.blueGrey.shade400 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoChip(
                      icon: Icons.storage_outlined,
                      label: 'المخزون: ${notification.stock}',
                      color: isRead
                          ? Colors.grey.shade400
                          : Colors.teal.shade400,
                    ),
                    _buildInfoChip(
                      icon: Icons.warning_amber_outlined,
                      label: 'الحد الأدنى: ${notification.minimum}',
                      color: isRead
                          ? Colors.grey.shade400
                          : Colors.orange.shade400,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat(
                      'yyyy-MM-dd hh:mm a',
                    ).format(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey.shade300,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
