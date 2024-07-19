enum ServiceType { music, festiveCulture, wedding, publicEvent }

class ServiceTypeUtil {
  static const Map<ServiceType, String> businessTypeMap = {
    ServiceType.music: "Konser Musik",
    ServiceType.festiveCulture: "Festival Budaya",
    ServiceType.wedding: "Pernikahan",
    ServiceType.publicEvent: "Acara Umum"
  };

  static ServiceType fromString(String value) {
    return businessTypeMap.keys
        .firstWhere((element) => businessTypeMap[element] == value);
  }

  static String textOf(ServiceType value) {
    return businessTypeMap[value]!;
  }

  static String imageOf(ServiceType value) {
    switch (value) {
      case ServiceType.music:
        return "assets/images/music.png";
      case ServiceType.festiveCulture:
        return "assets/images/festive_culture.png";
      case ServiceType.wedding:
        return "assets/images/wedding.png";
      case ServiceType.publicEvent:
        return "assets/images/public_event.png";
    }
  }
}
