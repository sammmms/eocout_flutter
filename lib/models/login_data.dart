import 'package:eocout_flutter/utils/role_type_util.dart';

class LoginData {
  String email;
  String password;

  LoginData({this.email = "", this.password = ""});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
