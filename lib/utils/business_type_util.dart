enum BusinessType { music, festiveCulture, wedding, publicEvent }

class BusinessTypeUtil {
  static const Map<BusinessType, String> businessTypeMap = {
    BusinessType.music: "Konser Musik",
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

  static String imageOf(BusinessType value) {
    switch (value) {
      case BusinessType.music:
        return "assets/images/music.png";
      case BusinessType.festiveCulture:
        return "assets/images/festive_culture.png";
      case BusinessType.wedding:
        return "assets/images/wedding.png";
      case BusinessType.publicEvent:
        return "assets/images/public_event.png";
    }
  }
}
