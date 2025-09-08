class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final int stock;
  final double minimum;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.stock,
    required this.minimum,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final notificationData = json['data'];
    return NotificationModel(
      id: json['id'],
      title: notificationData['title'],
      message: notificationData['message'],
      type: notificationData['type'],
      stock: notificationData['stock'],
      minimum: double.parse(notificationData['minimum']),
      isRead: json['read_at'] != null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
