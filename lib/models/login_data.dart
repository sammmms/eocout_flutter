import 'package:eocout_flutter/utils/role_type_util.dart';

class LoginData {
  String email;
  String password;
  UserRole role;

  LoginData({this.email = "", this.password = "", this.role = UserRole.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      email: json['email'],
      password: json['password'],
      role: UserRoleUtil.valueOf(json['role']),
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'role': UserRoleUtil.textOf(role),
      };
}
