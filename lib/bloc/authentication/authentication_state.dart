class AuthenticationState {
  final bool isAuthenticated;
  final bool isAuthenticating;
  final bool hasFailed;

  AuthenticationState(
      {this.isAuthenticated = false,
      this.isAuthenticating = false,
      this.hasFailed = false});

  factory AuthenticationState.authenticated() =>
      AuthenticationState(isAuthenticated: true);

  factory AuthenticationState.authenticating() =>
      AuthenticationState(isAuthenticating: true);

  factory AuthenticationState.failed() => AuthenticationState(hasFailed: true);
}
