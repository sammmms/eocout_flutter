import 'dart:io';

import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/notification_type_util.dart';

class NotificationData {
  final String id;
  final String content;
  final UserData? user;
  final DateTime createdAt;
  final NotificationType type;

  NotificationData({
    required this.id,
    required this.content,
    this.user,
    DateTime? createdAt,
    required this.type,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NotificationData.fromJson(Map<String, dynamic> json,
      {File? profilePic}) {
    return NotificationData(
      id: json['ref_id'],
      content: json['content'],
      user: json['ref_user'] == null
          ? null
          : UserData.fromJson(json['ref_user'], profilePicture: profilePic),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'])
              .toLocal()
              .add(const Duration(hours: 7)),
      type: NotificationTypeUtil.fromString(json['notification_type']) ??
          NotificationType.chat,
    );
  }

  factory NotificationData.empty() {
    return NotificationData(
      id: '',
      content: '',
      user: UserData.empty(),
      createdAt: DateTime.now(),
      type: NotificationType.userBooking,
    );
  }

  factory NotificationData.dummy() {
    return NotificationData(
      id: '1',
      content: 'This is a dummy notification',
      user: UserData.dummy(),
      createdAt: DateTime.now(),
      type: NotificationType.userBooking,
    );
  }
}
