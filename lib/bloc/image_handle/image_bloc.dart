import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

class ImageBloc {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );

  ImageBloc() {
    dio.interceptors.add(TokenInterceptor());
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
      printError(err);
      return null;
    }
  }

  Future<File?> loadImage(String imageId) async {
    try {
      var responsePicture = await dio.get('/image/$imageId',
          options: Options(responseType: ResponseType.bytes));
      Uint8List responseData = responsePicture.data;

      final tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/$imageId.jpg');
      await file.writeAsBytes(responseData);
      return file;
    } catch (err) {
      printError(err);
      return null;
    }
  }
}
