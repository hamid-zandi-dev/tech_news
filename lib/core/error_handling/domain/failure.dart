import 'package:equatable/equatable.dart';

/// Base abstract class for all domain failures
/// This follows Clean Architecture principles by keeping domain layer independent
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() =>
      'Failure(message: $message, code: $code, details: $details)';
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Database-related failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Authentication-related failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Authorization-related failures
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Business logic-related failures
class BusinessLogicFailure extends Failure {
  const BusinessLogicFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// No data found failures
class NoDataFoundFailure extends Failure {
  const NoDataFoundFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Timeout-related failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Parsing-related failures
class ParsingFailure extends Failure {
  const ParsingFailure({
    required super.message,
    super.code,
    super.details,
  });
}
