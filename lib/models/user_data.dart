import 'dart:io';
import 'package:eocout_flutter/models/profile_data.dart';
import 'package:eocout_flutter/utils/role_type_util.dart';

class UserData {
  // Server use
  final String userId;

  // Personal data
  final String username;
  final String fullname;
  final String email;

  final String address;
  final UserRole role;
  final File? profilePicture;

  // Additional data
  final bool isEmailVerified;
  final String pictureId;

  final ProfileData? profileData;

  UserData({
    this.userId = "",
    this.username = "",
    this.fullname = "",
    this.email = "",
    this.address = "",
    this.role = UserRole.user,
    this.profilePicture,
    this.isEmailVerified = false,
    this.pictureId = "",
    this.profileData,
  });

  factory UserData.fromJson(Map<String, dynamic> json, {File? profilePicture}) {
    return UserData(
      userId: json['id'] ?? "",
      username: json['username'] ?? "",
      fullname: json['full_name'] ?? '',
      email: json['email'] ?? "",
      address: json['address'] ?? '',
      role: UserRoleUtil.valueOf(json['role'] ?? ""),
      profilePicture: profilePicture,
      isEmailVerified: json['is_email_verified'] ?? false,
      pictureId: json['profile_pic_media_id'] ?? '',
      profileData: json['profile'] != null
          ? ProfileData.fromJson(json['profile'])
          : null,
    );
  }

  @override
  String toString() {
    return 'UserData{userId: $userId, username: $username, fullname: $fullname, email: $email, address: $address, role: $role, profilePicture: $profilePicture, isEmailVerified: $isEmailVerified, pictureId: $pictureId} profileData: ${profileData.toString()}';
  }

  UserData copyWith(
      {String? userId,
      String? username,
      String? fullname,
      String? email,
      String? address,
      UserRole? role,
      File? profilePicture,
      bool? isEmailVerified,
      String? pictureId,
      ProfileData? profileData}) {
    return UserData(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      pictureId: pictureId ?? this.pictureId,
      profileData: profileData ?? this.profileData,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': userId,
        'username': username,
        'full_name': fullname,
        'email': email,
        'address': address,
        'role': UserRoleUtil.textOf(role),
        'is_email_verified': isEmailVerified,
        'profile_pic_media_id': pictureId,
        'profile': profileData?.toJson(),
      };

  factory UserData.dummy({UserRole role = UserRole.user}) {
    return UserData(
      userId: '1',
      username: 'username',
      fullname: 'fullname',
      email: 'email',
      address: 'address',
      role: role,
      profilePicture: null,
      isEmailVerified: true,
      pictureId: '1',
      profileData: ProfileData.dummy(),
    );
  }

  factory UserData.empty() {
    return UserData(
      userId: '',
      username: '',
      fullname: '',
      email: '',
      address: '',
      role: UserRole.user,
      profilePicture: null,
      isEmailVerified: false,
      pictureId: '',
      profileData: ProfileData.empty(),
    );
  }
}

class EditableUserData {
  String fullname;
  String username;
  String address;
  File? picture;
  EditableProfileData profileData;
  EditableUserData({
    this.fullname = "",
    this.username = "",
    this.address = "",
    this.picture,
    EditableProfileData? profileData,
  }) : profileData = profileData ?? EditableProfileData();

  Map<String, dynamic> toJson(String? mediaId) => {
        if (fullname.isNotEmpty) 'full_name': fullname,
        if (address.isNotEmpty) 'address': address,
        if (mediaId != null) 'profile_pic_media_id': mediaId,
        if (username.isNotEmpty) 'username': username,
        if (profileData.toJson().isNotEmpty) 'profile': profileData.toJson(),
      };

  bool isEquals(UserData user) {
    return fullname == user.fullname &&
        address == user.address &&
        username == user.username &&
        ((picture == null || user.profilePicture == null)
            ? true
            : picture! == user.profilePicture!) &&
        profileData.isEqual(user.profileData);
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
        username: editableUserData.username == user.username
            ? ""
            : editableUserData.username,
        picture: editableUserData.picture,
        profileData: EditableProfileData.getDifference(
            user.profileData, editableUserData.profileData));
  }

  factory EditableUserData.fromUserData(UserData user) {
    return EditableUserData(
        fullname: user.fullname,
        address: user.address,
        username: user.username,
        picture: user.profilePicture,
        profileData: EditableProfileData.fromProfileData(user.profileData));
  }
}
