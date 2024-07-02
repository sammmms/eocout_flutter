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
      if (err.response?.data?['message'] == null) {
        print('Unknown Error');
        return;
      }
      String message = err.response?.data?['message'];
      String code = err.response?.data?['status'];
      print(ServerErrorParser.parseMessage(message));
      print(ServerErrorParser.parseCode(code));
      return;
    }
    print('Unknown Error');
  }
}
