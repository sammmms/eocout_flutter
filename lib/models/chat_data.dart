import 'dart:io';

import 'package:eocout_flutter/models/user_data.dart';

class ChatData {
  final String conversationId;
  final String latestMessage;
  final DateTime latestMessageTimestamp;
  final UserData withUser;

  ChatData(
      {required this.conversationId,
      required this.latestMessage,
      required this.latestMessageTimestamp,
      required this.withUser});

  factory ChatData.fromJson(Map<String, dynamic> json, {File? profilePic}) {
    return ChatData(
        conversationId: json['conversation_id'],
        latestMessage: json['latest_message'],
        latestMessageTimestamp:
            DateTime.parse(json['latest_message_timestamp']),
        withUser:
            UserData.fromJson(json['with_user'], profilePicture: profilePic));
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'latest_message': latestMessage,
      'latest_message_timestamp': latestMessageTimestamp.toIso8601String(),
      'with_user': withUser.toJson()
    };
  }

  factory ChatData.dummy() {
    return ChatData(
      conversationId: "1",
      latestMessage: "Halo ges, ketemu lagi dengan gue miaw augggggg",
      latestMessageTimestamp: DateTime.now(),
      withUser: UserData.dummy(),
    );
  }
}
