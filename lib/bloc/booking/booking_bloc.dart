import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/booking/booking_state.dart';
import 'package:eocout_flutter/bloc/image_handle/image_bloc.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/booking_filter.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/payment_status_util.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class BookingBloc {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
  ));

  final controller =
      BehaviorSubject<BookingState>.seeded(BookingState.initial());

  BookingBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void dispose() {
    dio.close();
  }

  void _updateStream(BookingState state) {
    if (controller.isClosed) {
      if (kDebugMode) print('BookingBloc: Stream is closed');
      return;
    }

    if (kDebugMode) print('BookingBloc: updated stream');
    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromErr(err);
    _updateStream(BookingState.error(error));
    return error;
  }

  BehaviorSubject<BookingState> get stream => controller;

  BookingState? get state => controller.valueOrNull;

  Future<AppError?> getBookingRequest({BookingFilter? bookingFilter}) async {
    try {
      _updateStream(BookingState.loading());

      String url = '/booking/request';

      if (bookingFilter?.toQuery().isNotEmpty ?? false) {
        url += '?${bookingFilter?.toQuery()}';
      }

      if (kDebugMode) print(url);

      var response = await dio.get(url);

      var data = response.data['data'];

      if (kDebugMode) print("BookingRequest: $data");

      if (data == null) {
        return _updateError('Data not found');
      }

      List<BookingData> bookings = [];

      for (var booking in data) {
        List? images = booking['service']['images'];

        List<File> loadedServiceImage = [];
        if (images != null && images.isNotEmpty) {
          for (var imageId in images) {
            File? image = await ImageBloc().loadImage(imageId);

            if (image != null) {
              loadedServiceImage.add(image);
            }
          }
        }

        String? profilePicId =
            booking['service']['profile']['profile_pic_media_id'];
        File? profilePic;
        if (profilePicId != null) {
          profilePic = await ImageBloc().loadImage(profilePicId);
        }

        BookingData bookingData = BookingData.fromJson(booking,
            serviceImage: loadedServiceImage, profilePic: profilePic);

        bookings.add(bookingData);
      }

      _updateStream(BookingState.success(bookings));

      return null;
    } catch (err) {
      printError(err, method: 'getBookingRequest');
      return _updateError(err);
    }
  }

  Future<AppError?> confirmBooking({required String bookingId}) async {
    try {
      var response = await dio.post('/booking/$bookingId/confirm');

      if (kDebugMode) {
        print(response);
      }

      return null;
    } catch (err) {
      printError(err, method: 'confirmBooking');
      return _updateError(err);
    }
  }

  Future<AppError?> cancelBooking({required String bookingId}) async {
    try {
      var response = await dio.post('/booking/$bookingId/user-cancel');

      if (kDebugMode) {
        print(response);
      }

      return null;
    } catch (err) {
      printError(err, method: 'cancelBooking');
      return _updateError(err);
    }
  }

  Future<AppError?> completeBooking({required String bookingId}) async {
    try {
      var response = await dio.post('/booking/$bookingId/complete');

      if (kDebugMode) {
        print(response);
      }

      return null;
    } catch (err) {
      printError(err, method: 'completeBooking');
      return _updateError(err);
    }
  }

  Future<AppError?> rejectBooking({required String bookingId}) async {
    try {
      var response = await dio.post('/booking/$bookingId/reject');

      if (kDebugMode) {
        print(response);
      }

      return null;
    } catch (err) {
      printError(err, method: 'rejectBooking');
      return _updateError(err);
    }
  }

  Future<AppError?> getAllBooking({BookingFilter? filter}) async {
    try {
      _updateStream(BookingState.loading());
      var response = await dio.get('/booking', queryParameters: {
        if (filter?.isCompletePayment ?? false) 'payment_status': 'completed'
      });

      var data = response.data['data'];

      if (kDebugMode) print(data);

      if (data == null) {
        return _updateError('Data not found');
      }

      List<BookingData> bookings = [];

      for (var booking in data) {
        List? images = booking['service']['images'];

        if (filter?.isPendingPayment ?? false) {
          PaymentStatus paymentStatus =
              PaymentStatusUtil.fromString(booking['payment_status']);

          if (paymentStatus != PaymentStatus.pending) continue;
        }

        List<File> loadedServiceImage = [];
        if (images != null && images.isNotEmpty) {
          for (var imageId in images) {
            File? image = await ImageBloc().loadImage(imageId);

            if (image != null) {
              loadedServiceImage.add(image);
            }
          }
        }

        String? profilePicId =
            booking['service']['profile']['profile_pic_media_id'];
        File? profilePic;
        if (profilePicId != null) {
          profilePic = await ImageBloc().loadImage(profilePicId);
        }

        BookingData bookingData = BookingData.fromJson(booking,
            serviceImage: loadedServiceImage, profilePic: profilePic);

        bookings.add(bookingData);
      }

      _updateStream(BookingState.success(bookings));

      return null;
    } catch (err) {
      printError(err, method: 'getAllBooking');
      return _updateError(err);
    }
  }

  Future<AppError?> createBooking(
      {required String serviceId, DateTime? bookingDate}) async {
    try {
      _updateStream(BookingState.loading());

      bookingDate ??= DateTime.now();

      Map<String, dynamic> data = {
        'service_id': serviceId,
        'booking_date': DateFormat('yyyy-MM-dd').format(bookingDate)
      };

      if (kDebugMode) {
        print(data);
      }

      await dio.post('/booking', data: data);

      _updateStream(BookingState.initial());

      return null;
    } catch (err) {
      printError(err, method: 'createBooking');
      return _updateError(err);
    }
  }

  Future<dynamic> paymentBooking(String bookingId) async {
    try {
      _updateStream(BookingState.loading());
      var response = await dio.post('/payment/pay', data: {
        "booking_id": bookingId,
        "success_redirect_url": "https://recrav.com"
      });

      if (kDebugMode) {
        print(response);
      }

      var data = response.data['data'];

      if (data == null) {
        return _updateError('Tidak ada data');
      }

      String? link = data['action']['mobile_web_checkout_url'];

      if (link == null) {
        return _updateError('Tidak ada link pembayaran');
      }

      _updateStream(BookingState.initial());
      return link;
    } catch (err) {
      printError(err, method: 'paymentBooking');
      return _updateError(err);
    }
  }
}
