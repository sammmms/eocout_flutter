import 'package:eocout_flutter/utils/notification_type_util.dart';

class NotificationData {
  final String id;
  final String content;
  final DateTime createdAt;
  final NotificationType type;

  NotificationData({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.type,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      type: NotificationTypeUtil.fromString(json['notification_type']),
    );
  }

  factory NotificationData.empty() {
    return NotificationData(
      id: '',
      content: '',
      createdAt: DateTime.now(),
      type: NotificationType.userBooking,
    );
  }

  factory NotificationData.dummy() {
    return NotificationData(
      id: '1',
      content: 'This is a dummy notification',
      createdAt: DateTime.now(),
      type: NotificationType.userBooking,
    );
  }
}
