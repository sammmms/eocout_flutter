import 'package:eocout_flutter/utils/business_type_util.dart';

class RegisterData {
  String username;
  String email;
  String password;
  String passwordConfirmation;

  RegisterData(
      {this.username = "",
      this.email = "",
      this.password = "",
      this.passwordConfirmation = ""});

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };
}

class EOREgisterData extends RegisterData {
  String? province;
  String? city;
  String? bankAccountNumber;
  String? npwpNumber;
  String identityNumber;
  String phoneNumber;
  String nibNumber;
  BusinessType? businessType;

  EOREgisterData({
    this.province,
    this.city,
    this.bankAccountNumber,
    this.identityNumber = "",
    this.npwpNumber,
    this.phoneNumber = "",
    this.nibNumber = "",
    this.businessType,
  }) : super(username: "", email: "", password: "", passwordConfirmation: "");

  @override
  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'province': province,
        'city': city,
        'accountNumber': bankAccountNumber,
        'identityNumber': identityNumber,
        'npwpNumber': npwpNumber,
        'phoneNumber': phoneNumber,
        'nibNumber': nibNumber,
        'businessType': businessType == null
            ? null
            : BusinessTypeUtil.textOf(businessType!),
      };
}
