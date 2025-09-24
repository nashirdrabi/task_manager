class ApiException implements Exception {
  final dynamic message;
  ApiException([this.message]);
  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "$message";
  }
}

class AuthException implements Exception {
  final dynamic message;
  AuthException([this.message]);
  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "$message";
  }
}
