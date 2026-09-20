sealed class AppException implements Exception {
  const new(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const new(super.message, {super.cause, this.statusCode});

  final int? statusCode;
}

final class UnauthorizedException extends AppException {
  const new([super.message = 'Authentication is required.']);
}

final class ForbiddenException extends AppException {
  const new([super.message = 'You do not have permission for this action.']);
}

final class NotFoundException extends AppException {
  const new([super.message = 'The requested resource was not found.']);
}

final class ValidationException extends AppException {
  const new(super.message, {super.cause, this.errors = const {}});

  final Map<String, List<String>> errors;
}

final class ServerException extends AppException {
  const new(super.message, {super.cause, this.statusCode});

  final int? statusCode;
}

final class DataParsingException extends AppException {
  const new(super.message, {super.cause});
}

final class RequestCancelledException extends AppException {
  const new([super.message = 'The request was cancelled.']);
}

final class StorageException extends AppException {
  const new(super.message, {super.cause});
}

final class UnknownException extends AppException {
  const new(super.message, {super.cause});
}
