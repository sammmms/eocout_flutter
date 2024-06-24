import 'dart:io';

import 'package:eocout_flutter/utils/role_type_util.dart';

class UserData {
  // Server use
  final String userId;

  // Personal data
  final String username;
  final String fullname;
  final String email;

  final String phone;
  final String address;
  final UserRole role;
  final String pictureLink;

  // Additional data
  final bool isEmailVerified;
  final String? pictureId;

  UserData({
    required this.userId,
    required this.username,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    this.pictureLink = "",
    required this.isEmailVerified,
    required this.pictureId,
  });

  factory UserData.fromJson(Map<String, dynamic> json, {String? pictureLink}) {
    return UserData(
      userId: json['id'],
      username: json['username'],
      fullname: json['full_name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: UserRoleUtil.valueOf(json['role']),
      pictureLink: pictureLink ?? '',
      isEmailVerified: json['is_email_verified'],
      pictureId: json['profile_pic_media_id'] ?? '',
    );
  }

  UserData copyWith(
      {String? userId,
      String? username,
      String? fullname,
      String? email,
      String? phone,
      String? address,
      UserRole? role,
      String? pictureLink,
      bool? isEmailVerified,
      String? pictureId}) {
    return UserData(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      pictureLink: pictureLink ?? this.pictureLink,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      pictureId: pictureId ?? this.pictureId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': userId,
        'username': username,
        'full_name': fullname,
        'email': email,
        'phone': phone,
        'address': address,
        'role': UserRoleUtil.textOf(role),
        'is_email_verified': isEmailVerified,
        'profile_pic_media_id': pictureId,
      };
}
