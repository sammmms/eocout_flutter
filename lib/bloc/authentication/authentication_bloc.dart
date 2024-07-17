import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/bloc/image_handle/image_bloc.dart';
import 'package:eocout_flutter/models/login_data.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));
  final controller = BehaviorSubject<AuthState>.seeded(AuthState());

  AuthBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  BehaviorSubject<AuthState> get stream => controller;

  AuthState? get state => controller.valueOrNull;

  void _updateStream(AuthState state) {
    if (controller.isClosed) {
      if (kDebugMode) print('AuthenticationBloc: Stream is closed');
      return;
    }

    if (kDebugMode) print('AuthenticationBloc: ${state.status}');
    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromErr(err);
    _updateStream(AuthState.failed(error));
    return error;
  }

  void dispose() {
    controller.close();
  }

  Future checkLogin() async {
    try {
      var token = await Store.getToken();
      if (token.isNotEmpty) {
        await refreshProfile();
      }
    } catch (err) {
      printError(err, method: "checkLogin");
      return _updateError(err);
    }
  }

  Future<AppError?> login(LoginData data) async {
    try {
      _updateStream(AuthState.authenticating());

      Map<String, dynamic> dataMap = data.toJson();

      String fcmToken = await Store.getFCMToken();

      dataMap['fcm_token'] = fcmToken;

      if (kDebugMode) {
        print(dataMap);
      }

      var responseToken = await dio.post('/auth/login', data: dataMap);
      var responseData = responseToken.data['data'];
      String token = responseData['token'];

      if (kDebugMode) {
        print("Token: $token");
      }

      await Store.saveToken(token);

      dio.interceptors.add(TokenInterceptor());
      var responseUser = await dio.get('/profile');
      var responseUserData = responseUser.data['data'];

      if (kDebugMode) {
        print(responseUserData);
      }
      UserData userData =
          UserData.fromJson(responseUserData as Map<String, dynamic>);

      if (kDebugMode) {
        print(userData.toJson());
      }

      if (userData.pictureId.isNotEmpty) {
        userData = userData.copyWith(
            profilePicture: await ImageBloc().loadImage(userData.pictureId));
      }

      _updateStream(AuthState(user: userData));
    } catch (err) {
      printError(err, method: "login");
      return _updateError(err);
    }
    return null;
  }

  void logout() {
    Store.clearAuthenticationStore();
    _updateStream(AuthState());
  }

  Future<AppError?> register(RegisterData data) async {
    try {
      _updateStream(AuthState.authenticating());

      Map<String, dynamic> dataMap = data.toJson();

      if (kDebugMode) {
        print(dataMap);
      }

      await dio.post('/auth/register', data: dataMap);

      _updateStream(AuthState(user: UserData.fromRegisterData(data)));
      return null;
    } catch (err) {
      printError(err, method: "register");
      return _updateError(err);
    }
  }

  Future refreshProfile() async {
    try {
      var response = await dio.get('/profile');
      var responseData = response.data['data'];

      if (kDebugMode) {
        print(responseData);
      }
      UserData userData =
          UserData.fromJson(responseData as Map<String, dynamic>);

      if (kDebugMode) {
        print(userData.toJson());
      }

      if (userData.pictureId.isNotEmpty) {
        userData = userData.copyWith(
            profilePicture: await ImageBloc().loadImage(userData.pictureId));
      }

      _updateStream(AuthState(user: userData));
    } catch (err) {
      printError(err, method: "refreshProfile");
      return _updateError(err);
    }
  }

  Future<AppError?> verifyEmail(String otpCode) async {
    try {
      UserData? currentUser = state?.user;

      if (currentUser == null) {
        return AppError('Terjadi kesalahan autentikasi', 401);
      }
      var response = await dio.post('/auth/verify-email',
          data: {'email': currentUser.email, 'verification_code': otpCode});
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Verify Email Success");
        }
        return null;
      }
      return AppError('Gagal verifikasi email');
    } catch (err) {
      printError(err, method: "verifyEmail");
      return AppError.fromErr(err);
    }
  }

  Future<AppError?> resendOTPCode() async {
    try {
      UserData? currentUser = state?.user;

      if (currentUser == null) {
        return AppError('Terjadi kesalahan autentikasi', 401);
      }

      if (kDebugMode) {
        print("requesting otp code...");
      }
      var response = await dio
          .post('/auth/resend-code', data: {'email': currentUser.email});
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Resend OTP Code Success");
        }
        return null;
      }
      return AppError('Gagal mengirim ulang kode OTP');
    } catch (err) {
      printError(err, method: "resendOTPCode");
      return AppError.fromErr(err);
    }
  }
}
