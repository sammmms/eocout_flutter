import 'package:dio/dio.dart';
import 'package:eocout_flutter/utils/store.dart';

class TokenInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Do something before request is sent
    // Get token from storage
    String? token = await Store.getToken();
    if (token == null) {
      return handler.reject(
          DioException(requestOptions: options, error: "Token is null"));
    }
    // Add token to header
    options.headers["Authorization"] = "Bearer $token";
    return handler.next(options); //continue
  }
}
