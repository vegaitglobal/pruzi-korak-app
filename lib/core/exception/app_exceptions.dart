sealed class AppException implements Exception {
  AppException();
}

class BadRequestException extends AppException {
  BadRequestException();
}

class UnauthorizedException extends AppException {
  UnauthorizedException();
}

class ForbiddenException extends AppException {
  ForbiddenException();
}

class NotFoundException extends AppException {
  NotFoundException();
}

class ServerException extends AppException {
  ServerException();
}

class NetworkException extends AppException {
  NetworkException();
}

class UnknownException extends AppException {
  UnknownException();
}
