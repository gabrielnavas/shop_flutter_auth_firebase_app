class HttpException implements Exception {
  final String message;
  final int status;

  HttpException({
    required this.message,
    required this.status,
  });

  @override
  String toString() {
    return message;
  }
}
