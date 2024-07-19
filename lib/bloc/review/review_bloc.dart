import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/image_handle/image_bloc.dart';
import 'package:eocout_flutter/bloc/review/review_state.dart';
import 'package:eocout_flutter/models/review_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class ReviewBloc {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
  ));

  final controller = BehaviorSubject<ReviewState>();

  ReviewBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(ReviewState state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print('ReviewBloc: Controller is closed');
      }
      return;
    }
    if (kDebugMode) {
      print('ReviewBloc: Update controller');
    }
    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromErr(err);
    _updateStream(ReviewState.error(error));
    return error;
  }

  void dispose() {
    controller.close();
  }

  BehaviorSubject<ReviewState> get stream => controller;

  ReviewState? get state => controller.valueOrNull;

  Future<void> fetchReviews(String eoServiceId) async {
    _updateStream(ReviewState.loading());
    try {
      String url = '/eo-service/$eoServiceId/review';

      if (kDebugMode) {
        print('ReviewBloc: Fetching reviews from $url');
      }

      final response = await dio.get(url);
      final data = response.data['data'] as List?;

      if (data == null) {
        _updateError("Ulasan tidak ditemukan");
        return;
      }

      if (kDebugMode) {
        print('ReviewBloc: $data');
      }

      List<ReviewData> reviews = [];
      for (var review in data) {
        String? profilePicMediaId = review['user']['profilePicMediaId'];

        File? profilePic;
        if (profilePicMediaId != null) {
          profilePic = await ImageBloc().loadImage(profilePicMediaId);
        }

        reviews.add(ReviewData.fromJson(review, profilePic: profilePic));
      }

      _updateStream(ReviewState.success(reviews));
    } catch (err) {
      printError(err, method: 'fetchReviews');
      _updateError(err);
    }
  }

  Future<AppError?> createReview(
      {required String eoServiceId,
      required EditableReviewData reviewData}) async {
    _updateStream(ReviewState.loading());
    try {
      String url = '/eo-service/review';

      if (kDebugMode) {
        print('ReviewBloc: Creating review to $url');
        print("ReviewBloc data: $reviewData");
      }

      final response = await dio.post(url, data: reviewData.toJson());
      final data = response.data['data'];

      if (kDebugMode) {
        print('ReviewBloc: $data');
      }

      _updateStream(ReviewState.initial());
      return null;
    } catch (err) {
      printError(err, method: 'createReview');
      return _updateError(err);
    }
  }
}
