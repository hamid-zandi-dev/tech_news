/// Base abstract class for all data layer exceptions
/// These exceptions are specific to the data layer and will be converted to domain failures
abstract class DataException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;
  final Exception? originalException;

  const DataException({
    required this.message,
    this.code,
    this.details,
    this.originalException,
  });

  @override
  String toString() =>
      'DataException(message: $message, code: $code, details: $details)';
}

/// Network-related exceptions
class NetworkException extends DataException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// Server-related exceptions
class ServerException extends DataException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// Database-related exceptions
class DatabaseException extends DataException {
  const DatabaseException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// Cache-related exceptions
class CacheException extends DataException {
  const CacheException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// Authentication-related exceptions
class AuthenticationException extends DataException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// Authorization-related exceptions
class AuthorizationException extends DataException {
  const AuthorizationException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// Validation-related exceptions
class ValidationException extends DataException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// Parsing-related exceptions
class ParsingException extends DataException {
  const ParsingException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// Timeout-related exceptions
class TimeoutException extends DataException {
  const TimeoutException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// Unknown/unexpected exceptions
class UnknownException extends DataException {
  const UnknownException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}

/// No data found exceptions
class NoDataFoundException extends DataException {
  const NoDataFoundException({
    required super.message,
    super.code,
    super.details,
    super.originalException,
  });
}
