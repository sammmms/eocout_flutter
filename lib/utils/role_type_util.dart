import 'package:collection/collection.dart';

enum UserRole {
  user,
  eventOrganizer,
}

class UserRoleUtil {
  static const Map<UserRole, String> roleTypeMap = {
    UserRole.user: 'User',
    UserRole.eventOrganizer: 'Eo'
  };

  static String textOf(UserRole role) {
    return roleTypeMap[role] ?? 'User';
  }

  static String readableTextOf(UserRole role) {
    switch (role) {
      case UserRole.user:
        return 'User';
      case UserRole.eventOrganizer:
        return 'Event Organizer';
      default:
        return 'User';
    }
  }

  static UserRole valueOf(String role) {
    return roleTypeMap.keys
            .firstWhereOrNull((key) => roleTypeMap[key] == role) ??
        UserRole.user;
  }
}
