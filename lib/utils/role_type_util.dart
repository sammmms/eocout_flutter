import 'package:collection/collection.dart';

enum UserRole {
  basicUser,
  eventOrganizer,
}

class UserRoleUtil {
  static const Map<UserRole, String> roleTypeMap = {
    UserRole.basicUser: 'basicUser',
    UserRole.eventOrganizer: 'eventOrganizer'
  };

  static String textOf(UserRole role) {
    return roleTypeMap[role] ?? 'basicUser';
  }

  static UserRole valueOf(String role) {
    return roleTypeMap.keys
            .firstWhereOrNull((key) => roleTypeMap[key] == role) ??
        UserRole.basicUser;
  }
}
