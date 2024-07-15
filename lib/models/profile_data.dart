import 'package:eocout_flutter/utils/business_type_util.dart';

class ProfileData {
  final String identityNumber;
  final String phoneNumber;
  final String province;
  final String city;
  final String bankNumber;
  final String taxIdentityNumber;
  final String businessIdentityNumber;
  final String preferredBusinessCategoryId;

  ProfileData({
    required this.identityNumber,
    required this.phoneNumber,
    required this.province,
    required this.city,
    required this.bankNumber,
    required this.taxIdentityNumber,
    required this.businessIdentityNumber,
    required this.preferredBusinessCategoryId,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      identityNumber: json['nik'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      province: json['province'] ?? "",
      city: json['city'] ?? "",
      bankNumber: json['bank_number'] ?? "",
      taxIdentityNumber: json['npwp_number'] ?? "",
      businessIdentityNumber: json['nib_number'] ?? "",
      preferredBusinessCategoryId: json['preferred_business_category_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nik": identityNumber,
      "phone_number": phoneNumber,
      "province": province,
      "city": city,
      "bank_number": bankNumber,
      "npwp_number": taxIdentityNumber,
      "nib_number": businessIdentityNumber,
      "preferred_business_category_id": preferredBusinessCategoryId,
    };
  }

  factory ProfileData.dummy() {
    return ProfileData(
      identityNumber: "1234567890",
      phoneNumber: "081234567890",
      province: "DKI Jakarta",
      city: "Jakarta",
      bankNumber: "1234567890",
      taxIdentityNumber: "1234567890",
      businessIdentityNumber: "1234567890",
      preferredBusinessCategoryId: "1",
    );
  }

  factory ProfileData.empty() {
    return ProfileData(
      identityNumber: "",
      phoneNumber: "",
      province: "",
      city: "",
      bankNumber: "",
      taxIdentityNumber: "",
      businessIdentityNumber: "",
      preferredBusinessCategoryId: "",
    );
  }

  @override
  String toString() {
    return 'ProfileData{identityNumber: $identityNumber, phoneNumber: $phoneNumber, location: $province,$city, bankNumber: $bankNumber, taxIdentityNumber: $taxIdentityNumber, businessIdentityNumber: $businessIdentityNumber, preferredBusinessCategoryId: $preferredBusinessCategoryId';
  }

  bool isRequiredFilled() {
    return identityNumber.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        province.isNotEmpty &&
        city.isNotEmpty &&
        businessIdentityNumber.isNotEmpty &&
        preferredBusinessCategoryId.isNotEmpty;
  }
}

class EditableProfileData {
  String identityNumber;
  String phoneNumber;
  String? province;
  String city;
  String bankNumber;
  String taxIdentityNumber;
  String businessIdentityNumber;
  String preferredBusinessCategoryId;
  BusinessType? preferredBusinessCategory;

  EditableProfileData(
      {this.identityNumber = "",
      this.phoneNumber = "",
      this.province = "",
      this.city = "",
      this.bankNumber = "",
      this.taxIdentityNumber = "",
      this.businessIdentityNumber = "",
      this.preferredBusinessCategoryId = "",
      this.preferredBusinessCategory});

  bool get isFilled {
    return identityNumber.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        province!.isNotEmpty &&
        city.isNotEmpty &&
        bankNumber.isNotEmpty &&
        taxIdentityNumber.isNotEmpty &&
        businessIdentityNumber.isNotEmpty &&
        preferredBusinessCategoryId.isNotEmpty;
  }

  bool isEqual(ProfileData? profileData) {
    if (profileData == null && isFilled) return false;
    if (profileData == null) return true;
    return identityNumber == profileData.identityNumber &&
        phoneNumber == profileData.phoneNumber &&
        province == profileData.province &&
        city == profileData.city &&
        bankNumber == profileData.bankNumber &&
        taxIdentityNumber == profileData.taxIdentityNumber &&
        businessIdentityNumber == profileData.businessIdentityNumber &&
        preferredBusinessCategoryId == profileData.preferredBusinessCategoryId;
  }

  factory EditableProfileData.fromProfileData(ProfileData? profileData) {
    if (profileData == null) return EditableProfileData();
    return EditableProfileData(
      identityNumber: profileData.identityNumber,
      phoneNumber: profileData.phoneNumber,
      province: profileData.province,
      city: profileData.city,
      bankNumber: profileData.bankNumber,
      taxIdentityNumber: profileData.taxIdentityNumber,
      businessIdentityNumber: profileData.businessIdentityNumber,
      preferredBusinessCategoryId: profileData.preferredBusinessCategoryId,
    );
  }

  factory EditableProfileData.getDifference(
      ProfileData? profileData, EditableProfileData editableProfileData) {
    if (profileData == null) return editableProfileData;
    return EditableProfileData(
      identityNumber:
          editableProfileData.identityNumber == profileData.identityNumber
              ? ""
              : editableProfileData.identityNumber,
      phoneNumber: editableProfileData.phoneNumber == profileData.phoneNumber
          ? ""
          : editableProfileData.phoneNumber,
      province: editableProfileData.province == profileData.province
          ? ""
          : editableProfileData.province,
      city: editableProfileData.city == profileData.city
          ? ""
          : editableProfileData.city,
      bankNumber: editableProfileData.bankNumber == profileData.bankNumber
          ? ""
          : editableProfileData.bankNumber,
      taxIdentityNumber:
          editableProfileData.taxIdentityNumber == profileData.taxIdentityNumber
              ? ""
              : editableProfileData.taxIdentityNumber,
      businessIdentityNumber: editableProfileData.businessIdentityNumber ==
              profileData.businessIdentityNumber
          ? ""
          : editableProfileData.businessIdentityNumber,
      preferredBusinessCategoryId:
          editableProfileData.preferredBusinessCategoryId ==
                  profileData.preferredBusinessCategoryId
              ? ""
              : editableProfileData.preferredBusinessCategoryId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (identityNumber.isNotEmpty) 'nik': identityNumber,
      if (phoneNumber.isNotEmpty) 'phone_number': phoneNumber,
      if (province?.isNotEmpty ?? false) 'province': province,
      if (city.isNotEmpty) 'city': city,
      if (bankNumber.isNotEmpty) 'bank_number': bankNumber,
      if (taxIdentityNumber.isNotEmpty) 'npwp_number': taxIdentityNumber,
      if (businessIdentityNumber.isNotEmpty)
        'nib_number': businessIdentityNumber,
      if (preferredBusinessCategoryId.isNotEmpty)
        'preferred_business_category_id': preferredBusinessCategoryId,
    };
  }
}
