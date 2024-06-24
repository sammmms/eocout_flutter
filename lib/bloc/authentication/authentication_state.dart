import 'package:eocout_flutter/models/user_data.dart';

class AuthState {
  final UserData? user;
  final bool isAuthenticating;
  final bool hasFailed;

  get status => user != null
      ? 'Authenticated'
      : hasFailed
          ? 'Failed'
          : 'Loading';

  AuthState({this.isAuthenticating = false, this.hasFailed = false, this.user});

  factory AuthState.authenticating() => AuthState(isAuthenticating: true);

  factory AuthState.failed() => AuthState(hasFailed: true);

  factory AuthState.resetState() => AuthState();
}
