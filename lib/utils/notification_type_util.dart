import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum NotificationType { userBooking, chat, payment }

class NotificationTypeUtil {
  static const Map<NotificationType, String> notificationTypeMap = {
    NotificationType.userBooking: 'user_booking',
    NotificationType.chat: 'chat',
    NotificationType.payment: 'payment',
  };

  static NotificationType? fromString(String? value) {
    return notificationTypeMap.keys
        .firstWhereOrNull((element) => notificationTypeMap[element] == value);
  }

  static String textOf(NotificationType value) {
    return notificationTypeMap[value]!;
  }

  static IconData iconOf(NotificationType value) {
    switch (value) {
      case NotificationType.userBooking:
        return Icons.notifications;
      case NotificationType.chat:
        return Icons.chat;
      case NotificationType.payment:
        return Icons.payment;
    }
  }
}
