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

  }

  void logout() {
    _updateStream(AuthenticationState());
  }

  void register(RegisterData data) {}
}
