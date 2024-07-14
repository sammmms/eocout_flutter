import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/category/category_state.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
  ));

  final controller = BehaviorSubject<CategoryState>();

  Stream<CategoryState> get stream => controller.stream;

  CategoryState? get currentState => controller.valueOrNull;

  void dispose() {
    controller.close();
  }

  void _updateStream(CategoryState state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print("category stream is closed");
      }
      return;
    }

    if (kDebugMode) {
      print("successfully updated category stream");
    }
    controller.add(state);
  }

  AppError _updateError(Object err) {
    if (kDebugMode) {
      print("error: $err");
    }
    AppError error = AppError.fromErr(err);
    _updateStream(CategoryState.error(error));
    return error;
  }

  Future<void> getCategories() async {
    _updateStream(CategoryState.loading());
    try {
      final response = await dio.get("/eo-category");
      final data = response.data['data'];

      if (data == null) {
        throw "No data found";
      }

      List<EOCategory> categories = data
          .map<EOCategory>((category) => EOCategory.fromJson(category))
          .toList();

      _updateStream(CategoryState.success(categories));
    } catch (err) {
      _updateError(err);
    }
  }
}
