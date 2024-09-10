class HttpFormValidationException implements Exception {
  final dynamic message;

  HttpFormValidationException([this.message]);

  @override
  String toString() {
    return message['message'];
  }

  getErrors() {
    return message['errors'];
  }
}
