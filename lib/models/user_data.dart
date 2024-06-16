import 'package:eocout_flutter/utils/role_type_util.dart';

class UserData {
  final String token;
  final String name;
  final String email;
  final String phone;
  final String address;
  final UserRole role;
  final String photo;

  UserData({
    required this.token,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    required this.photo,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      token: json['token'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      role: UserRoleUtil.valueOf(json['role']),
      photo: json['photo'],
    );
  }
}
