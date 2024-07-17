import 'package:eocout_flutter/utils/payment_status_util.dart';
import 'package:eocout_flutter/utils/status_util.dart';

class BookingFilter {
  final Status status;
  final PaymentStatus paymentStatus;

  BookingFilter(
      {this.status = Status.all, this.paymentStatus = PaymentStatus.all});

  String toQuery() {
    List<String> query = [];
    if (status != Status.all) {
      query.add('booking_status=${StatusUtil.textOf(status)}');
    }
    if (paymentStatus != PaymentStatus.all) {
      query.add('payment_status=${PaymentStatusUtil.textOf(paymentStatus)}');
    }
    return query.join('&');
  }

  factory BookingFilter.pending() {
    return BookingFilter(
        status: Status.pending, paymentStatus: PaymentStatus.pending);
  }

  factory BookingFilter.completed() {
    return BookingFilter(
        status: Status.completed, paymentStatus: PaymentStatus.completed);
  }
}
