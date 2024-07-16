import 'dart:io';

import 'package:eocout_flutter/models/business_data.dart';
import 'package:eocout_flutter/utils/status_util.dart';

class BookingData {
  DateTime bookingDate;
  String id;
  Status paymentStatus;
  BusinessData businessData;
  Status status;

  BookingData({
    required this.bookingDate,
    required this.id,
    required this.paymentStatus,
    required this.businessData,
    required this.status,
  });

  factory BookingData.fromJson(Map<String, dynamic> json,
      {List<File>? serviceImage, File? profilePic}) {
    return BookingData(
      bookingDate: DateTime.parse(json['booking_date']).toLocal(),
      id: json['id'],
      paymentStatus: StatusUtil.fromText(json['payment_status']),
      businessData: BusinessData.fromJson(json['service'],
          images: serviceImage, profilePic: profilePic),
      status: StatusUtil.fromText(json['status']),
    );
  }

  factory BookingData.empty() {
    return BookingData(
      bookingDate: DateTime.now(),
      id: '',
      paymentStatus: Status.pending,
      businessData: BusinessData.empty(),
      status: Status.pending,
    );
  }

  factory BookingData.dummy() {
    return BookingData(
      bookingDate: DateTime.now(),
      id: '1',
      paymentStatus: Status.pending,
      businessData: BusinessData.dummy(),
      status: Status.pending,
    );
  }
}
