enum Status { pending, confirmed, completed, cancelled, all }

class StatusUtil {
  static const Map<Status, String> statusMap = {
    Status.pending: 'pending',
    Status.confirmed: 'confirmed',
    Status.cancelled: 'cancelled',
    Status.completed: 'completed',
  };

  static Status fromText(String text) {
    return statusMap.entries
        .firstWhere((element) => element.value == text.toLowerCase())
        .key;
  }

  static String textOf(Status status) {
    return statusMap[status]!;
  }

  static int compare(Status statusA, Status statusB) {
    bool isGreater =
        Status.values.indexOf(statusA) > Status.values.indexOf(statusB);
    bool isEqual =
        Status.values.indexOf(statusA) == Status.values.indexOf(statusB);
    return isEqual
        ? 0
        : isGreater
            ? 1
            : -1;
  }
}
