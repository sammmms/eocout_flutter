class ProfileData {
  final String identityNumber;
  final String phoneNumber;
  final String location;
  final String bankNumber;
  final String taxIdentityNumber;
  final String businessIdentityNumber;
  final String preferredBusinessCategoryId;

  ProfileData({
    required this.identityNumber,
    required this.phoneNumber,
    required this.location,
    required this.bankNumber,
    required this.taxIdentityNumber,
    required this.businessIdentityNumber,
    required this.preferredBusinessCategoryId,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      identityNumber: json['nik'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      location: json['location'] ?? "",
      bankNumber: json['bank_number'] ?? "",
      taxIdentityNumber: json['npwp'] ?? "",
      businessIdentityNumber: json['nib'] ?? "",
      preferredBusinessCategoryId: json['preferred_business_category_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nik": identityNumber,
      "phone_number": phoneNumber,
      "location": location,
      "bank_number": bankNumber,
      "npwp": taxIdentityNumber,
      "nib": businessIdentityNumber,
      "preferred_business_category_id": preferredBusinessCategoryId,
    };
  }

  factory ProfileData.dummy() {
    return ProfileData(
      identityNumber: "1234567890",
      phoneNumber: "081234567890",
      location: "Jakarta",
      bankNumber: "1234567890",
      taxIdentityNumber: "1234567890",
      businessIdentityNumber: "1234567890",
      preferredBusinessCategoryId: "1",
    );
  }

  @override
  String toString() {
    return 'ProfileData{identityNumber: $identityNumber, phoneNumber: $phoneNumber, location: $location, bankNumber: $bankNumber, taxIdentityNumber: $taxIdentityNumber, businessIdentityNumber: $businessIdentityNumber, preferredBusinessCategoryId: $preferredBusinessCategoryId';
  }
}

class EditableProfileData {
  String identityNumber;
  String phoneNumber;
  String location;
  String bankNumber;
  String taxIdentityNumber;
  String businessIdentityNumber;
  String preferredBusinessCategoryId;

  EditableProfileData({
    this.identityNumber = "",
    this.phoneNumber = "",
    this.location = "",
    this.bankNumber = "",
    this.taxIdentityNumber = "",
    this.businessIdentityNumber = "",
    this.preferredBusinessCategoryId = "",
  });

  bool isEqual(ProfileData? profileData) {
    if (profileData == null) return false;
    return identityNumber == profileData.identityNumber &&
        phoneNumber == profileData.phoneNumber &&
        location == profileData.location &&
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
      location: profileData.location,
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
      location: editableProfileData.location == profileData.location
          ? ""
          : editableProfileData.location,
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
      if (location.isNotEmpty) 'location': location,
      if (bankNumber.isNotEmpty) 'bank_number': bankNumber,
      if (taxIdentityNumber.isNotEmpty) 'npwp': taxIdentityNumber,
      if (businessIdentityNumber.isNotEmpty) 'nib': businessIdentityNumber,
      if (preferredBusinessCategoryId.isNotEmpty)
        'preferred_business_category_id': preferredBusinessCategoryId,
    };
  }
}
