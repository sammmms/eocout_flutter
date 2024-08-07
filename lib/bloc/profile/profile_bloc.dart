import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/image_handle/image_bloc.dart';
import 'package:eocout_flutter/bloc/profile/profile_state.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));
  final controller = BehaviorSubject<ProfileState>();
  final AuthBloc authBloc;

  ProfileBloc(this.authBloc) {
    dio.interceptors.add(TokenInterceptor());
    authBloc.stream.listen((state) {
      if (state.user != null) {
        _updateStream(ProfileState.success(state.user));
      }
    });
  }

  void _updateStream(ProfileState state) {
    if (controller.isClosed) {
      if (kDebugMode) print('ProfileBloc: Stream is closed');
      return;
    }
    if (kDebugMode) print("ProfileBloc: Update Profile");
    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromErr(err);
    _updateStream(ProfileState.failure(error));
    return error;
  }

  void dispose() {
    controller.close();
  }

  Future<AppError?> updateProfile(EditableUserData user) async {
    try {
      String? mediaId;
      if (user.picture != null) {
        mediaId = await ImageBloc().uploadImage(user.picture!);
      }

      Map<String, dynamic> data = user.toJson(mediaId);

      if (kDebugMode) {
        print("update profile with $data");
      }

      await dio.put('/profile', data: data);
      await authBloc.refreshProfile();
      return null;
    } catch (err) {
      printError(err, method: "updateProfile");
      return _updateError(err);
    }
  }
}
