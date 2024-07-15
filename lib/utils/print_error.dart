import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:flutter/foundation.dart';

void printError(Object err) {
  if (kDebugMode) {
    if (err is DioException) {
      if (err is SocketException) {
        print('Tidak ada internet koneksi');
        return;
      }

      if (err.response is Map) {
        if (err.response?.data?['message'] == null) {
          print("message is null");
          print(err.response);
          return;
        }
        String message = err.response?.data?['message'];
        int code = err.response?.data?['status'];
        print(ServerErrorParser.parseMessage(message));
        print(ServerErrorParser.parseCode(code.toString()));
      } else {
        print("response is not a map");
        print(err.response);
      }
      return;
    }
    print(err);
  }
}
