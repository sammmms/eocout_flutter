import 'package:collection/collection.dart';

enum PaymentStatus { pending, completed, failed, all }

class PaymentStatusUtil {
  static const Map<PaymentStatus, String> paymentStatusMap = {
    PaymentStatus.pending: 'pending',
    PaymentStatus.completed: 'completed',
    PaymentStatus.failed: 'failed',
  };

  static PaymentStatus fromString(String status) {
    return paymentStatusMap.entries
            .firstWhereOrNull(
                (element) => element.value == status.toLowerCase())
            ?.key ??
        PaymentStatus.pending;
  }

  static String textOf(PaymentStatus status) {
    return paymentStatusMap[status]!;
  }
}
