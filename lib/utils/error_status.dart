class ErrorStatus {
  final String message;
  final int statusCode;

  ErrorStatus(this.message, this.statusCode);

  @override
  String toString() {
    return "ErrorStatus{message: $message, statusCode: $statusCode}";
  }
}
