class HttpException implements Exception {
  final String message;
  final String error;

  HttpException(this.error, this.message);

  @override
  String toString() {
    return message;
  }
}
