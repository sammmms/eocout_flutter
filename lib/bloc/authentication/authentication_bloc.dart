import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));
  final controller = BehaviorSubject<AuthState>.seeded(AuthState());

  BehaviorSubject<AuthState> get stream => controller;

  void _updateStream(AuthState state) {
    if (controller.isClosed) {
      if (kDebugMode) print('AuthenticationBloc: Stream is closed');
      return;
    }

    if (kDebugMode) print('AuthenticationBloc: ${state.status}');
    controller.add(state);
  }

  void dispose() {
    controller.close();
  }

  Future checkLogin() async {
    await Store.getUser().then((user) {
      if (user != null) {
        _updateStream(AuthState(user: user));
      }
    });
  }

  Future<ErrorStatus?> login(LoginData data) async {
    try {
      _updateStream(AuthState.authenticating());

      var responseToken = await dio.post('/auth/login', data: data.toJson());
      var responseData = responseToken.data['data'];
      String token = responseData['token'];
      await Store.saveToken(token);

      dio.interceptors.add(TokenInterceptor());
      var responseUser = await dio.get('/profile');
      var responseUserData = responseUser.data['data'];

      print(responseUserData);
      UserData userData =
          UserData.fromJson(responseUserData as Map<String, dynamic>);

      print(userData.toJson());

      if (userData.pictureId != null) {
        try {
          var responsePicture = await dio.get('/image/${userData.pictureId}');
          var responseData = responsePicture.data['data'];
          String imageLink = responseData['image'];

          userData = userData.copyWith(pictureLink: imageLink);
        } catch (err) {
          if (kDebugMode) {
            print("Error: $err");
          }
        }
      }

      await Store.saveUser(userData);
      _updateStream(AuthState(user: userData));
    } catch (err) {
      if (err is DioException) {
        if (err.response?.statusCode == 403) {
          if (kDebugMode) {
            print("Error: ${err.response}");
          }
          _updateStream(AuthState.failed());
          return ErrorStatus("Email atau password salah.", 403);
        }
      }
      if (kDebugMode) {
        print("Error: $err");
      }
      _updateStream(AuthState.failed());
      return ErrorStatus("Terjadi kesalahan.", 500);
    }
    return null;
  }

  void logout() {
    _updateStream(AuthState());
  }

  Future<ErrorStatus?> register(RegisterData data) async {
    try {
      _updateStream(AuthState.authenticating());

      await dio.post('/auth/register', data: data.toJson());

      _updateStream(AuthState.resetState());
      return null;
    } catch (err) {
      if (err is DioException) {
        if (err.response?.statusCode == 409) {
          _updateStream(AuthState.failed());
          return ErrorStatus("Akun telah terdaftar.", 409);
        }
      }
      if (kDebugMode) {
        print("Error: $err");
      }
      _updateStream(AuthState.failed());
      return ErrorStatus("Terjadi kesalahan.", 500);
    }
  }
}
