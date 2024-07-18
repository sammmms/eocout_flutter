import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/image_handle/image_bloc.dart';
import 'package:eocout_flutter/bloc/notification/notification_state.dart';
import 'package:eocout_flutter/models/notification_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class NotificationBloc {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );

  final controller = BehaviorSubject<NotificationState>();

  final currentChatId = BehaviorSubject<String>();

  Stream<NotificationState> get stream => controller.stream;

  NotificationState? get state => controller.valueOrNull;

  NotificationBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(NotificationState state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print('NotificationBloc: Stream is closed');
      }
      return;
    }
    if (kDebugMode) {
      print('NotificationBloc: updated stream');
    }
    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromErr(err);
    _updateStream(NotificationState.error(error));
    return error;
  }

  Future<void> fetchNotifications() async {
    _updateStream(NotificationState.loading());
    try {
      final response = await dio.get('/notification');
      var data = response.data['data'];

      if (kDebugMode) {
        print('NotificationBloc: fetchNotifications $data');
      }

      if (data == null) {
        throw AppError('Gagal mengambil data notifikasi');
      }

      List<NotificationData> notificationData = [];
      for (var notification in data) {
        var image = notification['ref_user']['profile_pic_media_id'];

        File? imageFile;
        if (image != null) {
          imageFile = await ImageBloc().loadImage(image);
        }

        notificationData.add(
            NotificationData.fromJson(notification, profilePic: imageFile));
      }

      notificationData.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      DateTime? lastSeen = await Store.getLastSeenNotification();

      int totalUnread = notificationData
          .where((element) =>
              element.createdAt.isAfter(lastSeen ?? DateTime.now()))
          .length;

      _updateStream(NotificationState.success(notificationData,
          totalUnread: totalUnread));
    } catch (err) {
      printError(err, method: "fetchNotifications");
      _updateError(err);
    }
  }
}
