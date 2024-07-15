import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/image_handle/image_bloc.dart';
import 'package:eocout_flutter/bloc/service/service_state.dart';
import 'package:eocout_flutter/models/business_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class ServiceBloc {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
  ));

  final controller = BehaviorSubject<ServiceState>();

  Stream<ServiceState> get stream => controller.stream;

  ServiceState? get currentState => controller.valueOrNull;

  ServiceBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void dispose() {
    controller.close();
  }

  void _updateStream(ServiceState state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print("service stream is closed");
      }
      return;
    }

    if (kDebugMode) {
      print("successfully updated service stream");
    }

    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromErr(err);
    _updateStream(ServiceState.error(error));
    return error;
  }

  Future<void> getServices({required String categoryId}) async {
    _updateStream(ServiceState.loading());
    try {
      final response = await dio
          .get("/eo-service", queryParameters: {"category_id": categoryId});

      final data = response.data['data'];

      if (data == null) throw "No data found";

      if (kDebugMode) {
        print('manage to get services');
        print(data);
      }

      List<BusinessData> businessData = [];

      for (var business in data) {
        List responseImages = business['images'] ?? [];

        if (responseImages.isEmpty) continue;

        List<File> images = [];

        for (var imageId in responseImages) {
          File? image = await ImageBloc().loadImage(imageId);

          if (image != null) {
            images.add(image);
          }
        }

        File? profilePic;

        if (business['profile']['profile_pic_media_id'] != null) {
          profilePic = await ImageBloc()
              .loadImage(business['profile']['profile_pic_media_id']);
        }

        businessData.add(BusinessData.fromJson(business,
            images: images, profilePic: profilePic));
      }

      _updateStream(ServiceState.success(businessData));
    } catch (err) {
      printError(err);
      _updateError(err);
    }
  }

  Future<AppError?> createService(
      {required EditableBusinessData editableBusinessData}) async {
    _updateStream(ServiceState.loading());
    try {
      List<String> mediaIds = [];
      for (var image in editableBusinessData.images) {
        final mediaId = await ImageBloc().uploadImage(image);
        mediaIds.add(mediaId);
      }

      final editableBusinessDataParsed = editableBusinessData.toJson(mediaIds);

      if (kDebugMode) {
        print(editableBusinessDataParsed);
      }

      final response =
          await dio.post("/eo-service", data: editableBusinessDataParsed);

      if (kDebugMode) {
        print(response.data);
      }

      if (response.statusCode == 200) {
        _updateStream(ServiceState.success([]));
      }

      return null;
    } catch (err) {
      printError(err);
      return _updateError(err);
    }
  }

  Future<void> getOwnService() async {
    _updateStream(ServiceState.loading());
    try {
      final response = await dio.get("/eo-service/my");

      if (kDebugMode) {
        print('manage to get own services');
        print(response.data);
      }

      final data = response.data['data'];

      List<BusinessData> businessData = [];

      for (var business in data) {
        List responseImages = business['images'] ?? [];

        if (responseImages.isEmpty) continue;

        List<File> images = [];

        for (var imageId in responseImages) {
          File? image = await ImageBloc().loadImage(imageId);

          if (image != null) {
            images.add(image);
          }
        }

        File? profilePic;

        if (business['profile']['profile_pic_media_id'] != null) {
          profilePic = await ImageBloc()
              .loadImage(business['profile']['profile_pic_media_id']);
        }

        businessData.add(BusinessData.fromJson(business,
            images: images, profilePic: profilePic));
      }

      _updateStream(ServiceState.success(businessData));
    } catch (err) {
      printError(err);
      _updateError(err);
    }
  }

  Future<AppError?> deleteService({required String eoServiceId}) async {
    _updateStream(ServiceState.loading());
    try {
      final response =
          await dio.delete("/eo-service?eo_service_id=$eoServiceId");

      if (kDebugMode) {
        print('manage to delete service');
        print(response.data);
      }

      if (response.statusCode == 200) {
        _updateStream(ServiceState.success([]));
      }

      return null;
    } catch (err) {
      printError(err);
      return _updateError(err);
    }
  }
}
