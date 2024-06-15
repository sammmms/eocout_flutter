enum BusinessType { music, festiveCulture, wedding, publicEvent }

class BusinessTypeUtil {
  static const Map<BusinessType, String> businessTypeMap = {
    BusinessType.music: "Musik",
    BusinessType.festiveCulture: "Festival Budaya",
    BusinessType.wedding: "Pernikahan",
    BusinessType.publicEvent: "Acara Umum"
  };

  static BusinessType fromString(String value) {
    return businessTypeMap.keys
        .firstWhere((element) => businessTypeMap[element] == value);
  }

  static String textOf(BusinessType value) {
    return businessTypeMap[value]!;
  }
}
