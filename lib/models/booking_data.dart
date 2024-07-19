import 'dart:io';

import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/utils/payment_status_util.dart';
import 'package:eocout_flutter/utils/status_util.dart';

class BookingData {
  DateTime bookingDate;
  String id;
  PaymentStatus paymentStatus;
  Status status;
  ServiceData businessData;

  BookingData({
    required this.bookingDate,
    required this.id,
    required this.paymentStatus,
    required this.businessData,
    required this.status,
  });
  bool get isCancelled => status == Status.cancelled;

  bool get isNotPaid =>
      status == Status.confirmed && paymentStatus == PaymentStatus.pending;

  bool get isPaid => paymentStatus == PaymentStatus.completed;

  bool get isComplete =>
      status == Status.completed && paymentStatus == PaymentStatus.completed;

  bool get isConfirmed => status == Status.confirmed;

  factory BookingData.fromJson(Map<String, dynamic> json,
      {List<File>? serviceImage, File? profilePic}) {
    return BookingData(
      bookingDate: DateTime.parse(json['booking_date']).toLocal(),
      id: json['id'],
      paymentStatus: PaymentStatusUtil.fromString(json['payment_status']),
      businessData: ServiceData.fromJson(json['service'],
          images: serviceImage, profilePic: profilePic),
      status: StatusUtil.fromText(json['status']),
    );
  }

  factory BookingData.empty() {
    return BookingData(
      bookingDate: DateTime.now(),
      id: '',
      paymentStatus: PaymentStatus.pending,
      businessData: ServiceData.empty(),
      status: Status.pending,
    );
  }

  factory BookingData.dummy() {
    return BookingData(
      bookingDate: DateTime.now(),
      id: '1',
      paymentStatus: PaymentStatus.pending,
      businessData: ServiceData.dummy(),
      status: Status.pending,
    );
  }
}
