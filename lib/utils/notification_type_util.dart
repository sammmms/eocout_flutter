import 'package:collection/collection.dart';

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
}
