import 'package:eocout_flutter/utils/role_type_util.dart';

class RegisterData {
  String username;
  String email;
  String password;
  UserRole role;

  RegisterData(
      {this.username = "",
      this.email = "",
      this.password = "",
      this.role = UserRole.user});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'username': username,
        'role': UserRoleUtil.textOf(role),
      };

  @override
  String toString() {
    return 'RegisterData{username: $username, email: $email, password: $password, role: $role}';
  }
}
