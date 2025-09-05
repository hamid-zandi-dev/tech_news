import 'package:dio/dio.dart';
import '../domain/failure.dart';
import '../data/data_exception.dart';

/// Error mapper that converts data layer exceptions to domain layer failures
/// This maintains Clean Architecture by keeping domain layer independent of data layer specifics
class ErrorMapper {
  /// Maps any exception to appropriate domain failure
  static Failure mapExceptionToFailure(dynamic exception) {
    if (exception is DataException) {
      return _mapDataExceptionToFailure(exception);
    } else if (exception is DioException) {
      return _mapDioExceptionToFailure(exception);
    } else if (exception is Exception) {
      return _mapGenericExceptionToFailure(exception);
    } else {
      return UnknownFailure(
        message: 'Unknown error occurred: ${exception.toString()}',
        details: {'exception': exception.toString()},
      );
    }
  }

  /// Maps data exceptions to domain failures
  static Failure _mapDataExceptionToFailure(DataException exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return NetworkFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      case ServerException:
        return ServerFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      case DatabaseException:
        return DatabaseFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      case CacheException:
        return CacheFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      case AuthenticationException:
        return AuthenticationFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      case AuthorizationException:
        return AuthorizationFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      case ValidationException:
        return ValidationFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      case ParsingException:
        return ParsingFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      case TimeoutException:
        return TimeoutFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      case NoDataFoundException:
        return NoDataFoundFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      default:
        return UnknownFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
    }
  }

  /// Maps Dio exceptions to domain failures
  static Failure _mapDioExceptionToFailure(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'Connection error occurred',
          code: 'CONNECTION_ERROR',
          details: {
            'type': dioException.type.toString(),
            'message': dioException.message,
            'response': dioException.response?.data,
          },
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutFailure(
          message: 'Request timeout occurred',
          code: 'TIMEOUT_ERROR',
          details: {
            'type': dioException.type.toString(),
            'message': dioException.message,
            'timeout': dioException.type.toString(),
          },
        );
      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 400 && statusCode < 500) {
            return ValidationFailure(
              message:
                  'Client error: ${dioException.response!.statusMessage ?? 'Bad request'}',
              code: statusCode.toString(),
              details: {
                'statusCode': statusCode,
                'response': dioException.response!.data,
                'headers': dioException.response!.headers.map,
              },
            );
          } else if (statusCode >= 500) {
            return ServerFailure(
              message:
                  'Server error: ${dioException.response!.statusMessage ?? 'Internal server error'}',
              code: statusCode.toString(),
              details: {
                'statusCode': statusCode,
                'response': dioException.response!.data,
                'headers': dioException.response!.headers.map,
              },
            );
          }
        }
        return ServerFailure(
          message: 'Bad response received',
          code: 'BAD_RESPONSE',
          details: {
            'statusCode': statusCode,
            'response': dioException.response?.data,
          },
        );
      case DioExceptionType.cancel:
        return NetworkFailure(
          message: 'Request was cancelled',
          code: 'REQUEST_CANCELLED',
          details: {
            'type': dioException.type.toString(),
            'message': dioException.message,
          },
        );
      case DioExceptionType.unknown:
      default:
        return UnknownFailure(
          message: 'Unknown network error occurred',
          code: 'UNKNOWN_NETWORK_ERROR',
          details: {
            'type': dioException.type.toString(),
            'message': dioException.message,
            'error': dioException.error?.toString(),
          },
        );
    }
  }

  /// Maps generic exceptions to domain failures
  static Failure _mapGenericExceptionToFailure(Exception exception) {
    return UnknownFailure(
      message: 'Unexpected error occurred: ${exception.toString()}',
      code: 'GENERIC_EXCEPTION',
      details: {
        'exception': exception.toString(),
        'type': exception.runtimeType.toString(),
      },
    );
  }

  /// Creates a network failure for no internet connection
  static Failure createNoInternetFailure() {
    return NetworkFailure(
      message: 'No internet connection available',
      code: 'NO_INTERNET_CONNECTION',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Creates a server failure for specific HTTP status codes
  static Failure createServerFailure(int statusCode, String? message) {
    return ServerFailure(
      message: message ?? 'Server error occurred',
      code: statusCode.toString(),
      details: {
        'statusCode': statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Creates a database failure
  static Failure createDatabaseFailure(String message, [String? code]) {
    return DatabaseFailure(
      message: message,
      code: code,
      details: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Creates a no data found failure
  static Failure createNoDataFoundFailure(String message) {
    return NoDataFoundFailure(
      message: message,
      code: 'NO_DATA_FOUND',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
