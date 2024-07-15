enum Status { pending, success, cancelled }

class StatusUtil {
  static const Map<Status, String> statusMap = {
    Status.pending: 'Pending',
    Status.success: 'Success',
    Status.cancelled: 'Cancelled',
  };

  static Status fromText(String text) {
    return statusMap.entries.firstWhere((element) => element.value == text).key;
  }

  static String textOf(Status status) {
    return statusMap[status]!;
  }
}
