import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/error_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));
  final controller = BehaviorSubject<UserData>();
  final AuthBloc authBloc;

  ProfileBloc(this.authBloc) {
    authBloc.stream.listen((state) {
      if (state.user != null) {
        controller.add(state.user!);
      }
    });
  }

  void dispose() {
    controller.close();
  }

  Future<ErrorStatus?> updateProfile(EditableUserData user) async {
    try {
      dio.interceptors.add(TokenInterceptor());
      String? mediaId;
      if (user.picture != null) {
        mediaId = await uploadImage(user.picture!);
      }
      await dio.put('/profile', data: user.toJson(mediaId));
      authBloc.refreshProfile();
      return null;
    } catch (err) {
      if (err is DioException) {
        if (kDebugMode) {
          print(err.response!);
        }
      }
      if (kDebugMode) {
        print(err);
      }
      return ErrorStatus("Terjadi kesalahan.", 400);
    }
  }

  Future uploadImage(File image) async {
    try {
      FormData formData = FormData.fromMap({
        "picture": await MultipartFile.fromFile(image.path),
      });
      var response = await dio.post('/image/upload', data: formData);
      var responseData = response.data['data'];
      var mediaId = responseData['media_id'];
      return mediaId;
    } catch (err) {
      if (err is DioException) {
        if (kDebugMode) {
          print("err dio upload image : \n ${err.response!}");
        }
      }
      if (kDebugMode) {
        print("err upload image : \n $err");
      }
      return null;
    }
  }
}
