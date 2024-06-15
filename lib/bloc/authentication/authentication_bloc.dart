import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc {
  final controller = BehaviorSubject<AuthenticationState>();

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

  void login() {
    _updateStream(AuthenticationState.authenticated());
  }

  void logout() {
    _updateStream(AuthenticationState());
  }

  void register(RegisterData data) {}
}
