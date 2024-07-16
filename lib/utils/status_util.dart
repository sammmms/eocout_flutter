enum Status { pending, confirmed, cancelled, completed }

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
}
