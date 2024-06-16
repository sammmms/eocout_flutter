import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc {
  final controller =
      BehaviorSubject<AuthenticationState>.seeded(AuthenticationState());

  get stream => controller;

  void _updateStream(AuthenticationState state) {
    if (controller.isClosed) {
      if (kDebugMode) print('AuthenticationBloc: Stream is closed');
      return;
    }

    if (kDebugMode) print('AuthenticationBloc: $state');
    controller.add(state);
  }

  void dispose() {
    controller.close();
  }

  void login() async {
    _updateStream(AuthenticationState.authenticating());
    await Future.delayed(const Duration(seconds: 3));
    _updateStream(AuthenticationState.authenticated());
  }

  void logout() {
    _updateStream(AuthenticationState());
  }

  void register(RegisterData data) {}
}
