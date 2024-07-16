import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/booking/booking_state.dart';
import 'package:eocout_flutter/bloc/image_handle/image_bloc.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  Future<AppError?> getBookingRequest() async {
    try {
      _updateStream(BookingState.loading());
      var response = await dio.get('/booking/request');

      var data = response.data['data'];

      if (kDebugMode) print(data);

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
      printError(err);
      return _updateError(err);
    }
  }

  Future<AppError?> confirmBooking({required String bookingId}) async {
    try {
      _updateStream(BookingState.loading());
      await dio.post('/booking/$bookingId/confirm');

      getBookings();

      return null;
    } catch (err) {
      printError(err);
      return _updateError(err);
    }
  }
}
