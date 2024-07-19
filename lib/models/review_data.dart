import 'dart:io';

import 'package:eocout_flutter/models/user_data.dart';

class ReviewData {
  final UserData user;
  final String serviceId;
  final String comment;
  final DateTime createdAt;
  final int rating;

  ReviewData(
      {required this.user,
      required this.serviceId,
      required this.comment,
      DateTime? createdAt,
      required this.rating})
      : createdAt = createdAt ?? DateTime.now();

  factory ReviewData.fromJson(Map<String, dynamic> json, {File? profilePic}) {
    return ReviewData(
      user: UserData.fromJson(json['user'], profilePicture: profilePic),
      comment: json['comment'] ?? "",
      serviceId: json['eo_service_id'],
      createdAt: DateTime.parse(json['created_at']),
      rating: json['rating'] is int
          ? json['rating']
          : int.tryParse(json['rating'].toString()) ?? 0,
    );
  }

  factory ReviewData.dummy() {
    return ReviewData(
      user: UserData.dummy(),
      comment: 'Lorem ipsum dolor sit amet',
      serviceId: '1',
      createdAt: DateTime.now(),
      rating: 5,
    );
  }

  factory ReviewData.empty() {
    return ReviewData(
      user: UserData.empty(),
      comment: '',
      serviceId: '',
      rating: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'eo_service_id': serviceId,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'rating': rating,
    };
  }
}

class EditableReviewData {
  final String serviceId;
  String comment;
  int rating;

  EditableReviewData(
      {this.comment = "", this.rating = 0, required this.serviceId});

  Map<String, dynamic> toJson() {
    return {
      'eo_service_id': serviceId,
      'comment': comment,
      'rating': rating,
    };
  }
}
