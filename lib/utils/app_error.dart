import 'dart:io';

import 'package:dio/dio.dart';

class AppError extends Error {
  final String message;
  final int? code;

  AppError(this.message, [this.code]);

  @override
  String toString() {
    return 'AppError{message: $message, code: $code}';
  }

  factory AppError.fromErr(Object err) {
    if (err is DioException) {
      if (err is SocketException) {
        return AppError('Tidak ada internet koneksi', null);
      }

      if (err.response?.data is Map) {
        if (err.response?.data?['message'] == null) {
          return AppError('Terjadi kesalahan', null);
        }
        String message = err.response?.data?['message'];
        String code = err.response?.data?['status'];
        return AppError(ServerErrorParser.parseMessage(message),
            ServerErrorParser.parseCode(code));
      } else {
        if (err.response != null) {
          return AppError(
              ServerErrorParser.parseMessage(err.response.toString()),
              ServerErrorParser.parseCode(err.response.toString()));
        }
        return AppError("Terjadi kesalahan", null);
      }
    }
    if (err is String) {
      return AppError(err, null);
    }
    return AppError('Terjadi kesalahan', null);
  }
}

class ServerErrorParser {
  static String parseMessage(String message) {
    if (message == "wrong credentials") {
      return "Email atau password salah";
    }

    if (message == "email or username has already exist") {
      return "Email atau username sudah terdaftar";
    }

    if (message == "invalid image ids") {
      return "ID gambar tidak valid";
    }

    if (message == "invalid username") {
      return "Username tidak valid";
    }

    if (message == "email not verified") {
      return "Email belum diverifikasi";
    }

    if (message == "wrong verification code") {
      return "Kode verifikasi salah";
    }

    if (message == "email already verified") {
      return "Email sudah diverifikasi";
    }

    if (message.contains("cannot send to myself")) {
      return "Tidak bisa mengirim pesan ke diri sendiri";
    }

    if (message == "you have already booked into same service id") {
      return "Anda sudah melakukan booking pada layanan ini";
    }

    if (message == "error code: 502") {
      return "Terjadi kesalahan pada server";
    }
    return message;
  }

  static int parseCode(String code) {
    if (code.contains('400')) {
      return 400;
    }
    if (code.contains('401')) {
      return 401;
    } else if (code.contains('402')) {
      return 402;
    } else if (code.contains('403')) {
      return 403;
    } else if (code.contains('404')) {
      return 404;
    } else if (code.contains('405')) {
      return 405;
    } else if (code.contains('406')) {
      return 406;
    } else if (code.contains('407')) {
      return 407;
    } else if (code.contains('408')) {
      return 408;
    } else if (code.contains('409')) {
      return 409;
    } else if (code.contains('410')) {
      return 410;
    } else if (code.contains('411')) {
      return 411;
    } else if (code.contains('412')) {
      return 412;
    } else if (code.contains('413')) {
      return 413;
    } else if (code.contains('414')) {
      return 414;
    } else if (code.contains('415')) {
      return 415;
    } else if (code.contains('416')) {
      return 416;
    } else if (code.contains('417')) {
      return 417;
    } else if (code.contains('418')) {
      return 418;
    } else if (code.contains('419')) {
      return 419;
    } else if (code.contains('420')) {
      return 420;
    } else if (code.contains('421')) {
      return 421;
    } else if (code.contains('422')) {
      return 422;
    } else if (code.contains('423')) {
      return 423;
    } else if (code.contains('424')) {
      return 424;
    } else if (code.contains('425')) {
      return 425;
    } else if (code.contains('426')) {
      return 426;
    } else if (code.contains('427')) {
      return 427;
    } else if (code.contains('428')) {
      return 428;
    } else if (code.contains('429')) {
      return 429;
    }

    return 500;
  }
}
