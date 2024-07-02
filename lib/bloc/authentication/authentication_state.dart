import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';

class AuthState {
  final UserData? user;
  final bool isAuthenticating;
  final bool hasError;
  final AppError? error;

  get status => user != null
      ? 'Authenticated'
      : hasError
          ? 'Failed'
          : 'Loading';

  AuthState(
      {this.isAuthenticating = false,
      this.hasError = false,
      this.user,
      this.error});

  factory AuthState.authenticating() => AuthState(isAuthenticating: true);

  factory AuthState.failed(AppError error) =>
      AuthState(hasError: true, error: error);

  factory AuthState.resetState() => AuthState();
}
