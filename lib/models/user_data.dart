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
  final File? profilePicture;

  // Additional data
  final bool isEmailVerified;
  final String pictureId;

  UserData({
    required this.userId,
    required this.username,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    this.profilePicture,
    required this.isEmailVerified,
    required this.pictureId,
  });

  factory UserData.fromJson(Map<String, dynamic> json, {File? profilePicture}) {
    return UserData(
      userId: json['id'],
      username: json['username'],
      fullname: json['full_name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: UserRoleUtil.valueOf(json['role']),
      profilePicture: profilePicture,
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
      File? profilePicture,
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
      profilePicture: profilePicture ?? this.profilePicture,
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

  factory UserData.dummy({UserRole role = UserRole.user}) {
    return UserData(
      userId: '1',
      username: 'username',
      fullname: 'fullname',
      email: 'email',
      phone: 'phone',
      address: 'address',
      role: role,
      profilePicture: null,
      isEmailVerified: true,
      pictureId: '1',
    );
  }
}

class EditableUserData {
  String fullname;
  String username;
  String address;
  String phone;
  File? picture;

  EditableUserData({
    this.fullname = "",
    this.username = "",
    this.address = "",
    this.phone = "",
    this.picture,
  });

  Map<String, dynamic> toJson(String? mediaId) => {
        if (fullname.isNotEmpty) 'full_name': fullname,
        if (address.isNotEmpty) 'address': address,
        if (phone.isNotEmpty) 'phone': phone,
        if (mediaId != null) 'profile_pic_media_id': mediaId,
        if (username.isNotEmpty) 'username': username,
      };

  bool isEquals(UserData user) {
    return fullname == user.fullname &&
        address == user.address &&
        phone == user.phone &&
        username == user.username &&
        ((picture == null || user.profilePicture == null)
            ? true
            : picture! == user.profilePicture!);
  }

  factory EditableUserData.getDifference(
      UserData user, EditableUserData editableUserData) {
    return EditableUserData(
      fullname: editableUserData.fullname == user.fullname
          ? ""
          : editableUserData.fullname,
      address: editableUserData.address == user.address
          ? ""
          : editableUserData.address,
      phone: editableUserData.phone == user.phone ? "" : editableUserData.phone,
      username: editableUserData.username == user.username
          ? ""
          : editableUserData.username,
      picture: editableUserData.picture,
    );
  }

  factory EditableUserData.fromUserData(UserData user) {
    return EditableUserData(
        fullname: user.fullname,
        address: user.address,
        phone: user.phone,
        username: user.username,
        picture: user.profilePicture);
  }
}
