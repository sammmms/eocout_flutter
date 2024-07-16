import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/balance/balance_state.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class BalanceBloc {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );

  final controller =
      BehaviorSubject<BalanceState>.seeded(BalanceState.initial());

  BalanceBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void dispose() {
    dio.close();
  }

  void _updateStream(BalanceState state) {
    if (controller.isClosed) {
      if (kDebugMode) print('BalanceBloc: Stream is closed');
      return;
    }
    if (kDebugMode) print('BalanceBloc: updated stream');
    controller.add(state);
  }

  BehaviorSubject<BalanceState> get stream => controller;

  BalanceState? get state => controller.valueOrNull;

  AppError _updateError(Object err) {
    AppError error = AppError.fromErr(err);
    _updateStream(BalanceState.error(error));
    return error;
  }

  Future<void> getBalance() async {
    try {
      _updateStream(BalanceState.loading());
      var response = await dio.get('/balance');

      var data = int.tryParse(response.data['data']['amount']);

      if (data == null) {
        throw Exception("Failed to parse balance data");
      }

      _updateStream(BalanceState.success(data));
    } catch (err) {
      printError(err, method: "getBalance");
      _updateError(err);
    }
  }
}
