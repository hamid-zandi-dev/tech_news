# Clean Architecture Error Handling Implementation

## Overview

This document describes the comprehensive error handling system implemented following Clean Architecture principles. The system provides proper abstraction layers, type-safe error handling, and maintains separation of concerns across all application layers.

## Architecture Layers

### 1. Domain Layer - `lib/core/error_handling/domain/failure.dart`

The domain layer defines abstract failure types that represent business logic errors. These failures are independent of any external dependencies and can be used across all layers.

#### Base Failure Class
```dart
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;
  
  const Failure({
    required this.message,
    this.code,
    this.details,
  });
}
```

#### Specific Failure Types
- **NetworkFailure**: Network connectivity issues
- **ServerFailure**: Server-side errors (5xx status codes)
- **DatabaseFailure**: Local database operation failures
- **CacheFailure**: Caching mechanism failures
- **AuthenticationFailure**: Authentication-related errors
- **AuthorizationFailure**: Authorization/permission errors
- **ValidationFailure**: Input validation errors (4xx status codes)
- **BusinessLogicFailure**: Domain-specific business rule violations
- **TimeoutFailure**: Request timeout errors
- **ParsingFailure**: Data parsing/deserialization errors
- **NoDataFoundFailure**: No data available scenarios
- **UnknownFailure**: Unexpected/unhandled errors

### 2. Data Layer - `lib/core/error_handling/data/data_exception.dart`

The data layer defines specific exceptions that represent technical errors from external sources (APIs, databases, etc.). These exceptions contain detailed technical information and are converted to domain failures.

#### Base Data Exception Class
```dart
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
}
```

#### Specific Exception Types
- **NetworkException**: Network connectivity issues
- **ServerException**: Server-side errors
- **DatabaseException**: Database operation failures
- **CacheException**: Cache operation failures
- **AuthenticationException**: Authentication failures
- **AuthorizationException**: Authorization failures
- **ValidationException**: Input validation failures
- **ParsingException**: Data parsing failures
- **TimeoutException**: Timeout errors
- **NoDataFoundException**: No data found scenarios
- **UnknownException**: Unexpected errors

### 3. Error Mapper - `lib/core/error_handling/mapper/error_mapper.dart`

The error mapper is responsible for converting data layer exceptions to domain layer failures. This maintains Clean Architecture by keeping the domain layer independent of data layer specifics.

#### Key Features
- **Exception to Failure Mapping**: Converts all types of exceptions to appropriate domain failures
- **DioException Handling**: Specialized handling for Dio HTTP client exceptions
- **Detailed Error Information**: Preserves error context and details
- **Fallback Mechanisms**: Handles unknown error types gracefully

#### Usage Example
```dart
try {
  // Some operation that might throw exceptions
} catch (e) {
  final failure = ErrorMapper.mapExceptionToFailure(e);
  // Use failure in domain layer
}
```

## Implementation Details

### Data Source Implementation

The remote data source (`RemoteArticlesDataSourceImpl`) now throws specific data exceptions:

```dart
// Network connectivity check
if (!hasInternet) {
  throw NetworkException(
    message: 'No internet connection available',
    code: 'NO_INTERNET_CONNECTION',
    details: {
      'query': query,
      'page': page,
      'timestamp': DateTime.now().toIso8601String(),
    },
    originalException: e,
  );
}

// Server errors
if (statusCode >= 500) {
  throw ServerException(
    message: 'Server error: ${response.statusMessage}',
    code: statusCode.toString(),
    details: {
      'statusCode': statusCode,
      'response': response.data,
      'query': query,
      'page': page,
    },
  );
}
```

### Repository Implementation

The repository layer converts data exceptions to domain failures:

```dart
Stream<Either<Failure, List<ArticleModel>>> _buildArticlesStream(Params params) async* {
  try {
    // Repository logic
  } catch (e) {
    // Convert any exception to domain failure
    final failure = ErrorMapper.mapExceptionToFailure(e);
    Logger.error("Repository error: ${failure.message}", tag: 'Repository');
    yield left(failure);
  }
}
```

### Presentation Layer Implementation

The BLoC handles domain failures and provides appropriate UI states:

```dart
ArticleListState _handleFailureResponse(Failure failure) {
  Logger.error('Article fetch failed: ${failure.toString()}', tag: 'ArticleListBloc');
  
  // Handle different failure types appropriately
  if (_articleListModel.isNotEmpty) {
    return GetArticleListState(ArticleListLoadedMoreErrorStatus());
  }
  
  return GetArticleListState(ArticleListErrorStatus(failure));
}
```

### UI Error Handling

The error handling factory widget provides specific UI for different failure types:

```dart
factory ErrorHandlingFactoryWidget(BuildContext context, Failure failure, {void Function()? onClickListener}) {
  if (failure is NetworkFailure) {
    return ErrorHandlingWidget(
      title: "No internet connection",
      description: "Please check your internet connection and try again",
      image: ImagesPath.noInternetConnectionError,
      tryAgainVisibility: true,
      onClickListener: onClickListener,
    );
  } else if (failure is ServerFailure) {
    return ErrorHandlingWidget(
      title: "Server error",
      description: "There is a problem connecting to the server. Please try again later",
      image: ImagesPath.serverError,
      tryAgainVisibility: true,
      onClickListener: onClickListener,
    );
  }
  // ... other failure types
}
```

## Benefits

### 1. **Clean Architecture Compliance**
- Domain layer is independent of external dependencies
- Clear separation of concerns across layers
- Proper abstraction and dependency inversion

### 2. **Type Safety**
- Compile-time error checking
- Specific failure types for different scenarios
- Rich error information with context

### 3. **Maintainability**
- Centralized error handling logic
- Easy to extend with new error types
- Consistent error handling across the application

### 4. **Debugging & Monitoring**
- Detailed error information with context
- Structured error logging
- Easy error tracking and analysis

### 5. **User Experience**
- Specific error messages for different scenarios
- Appropriate retry mechanisms
- Graceful error handling

## Error Flow

```
Data Layer Exception → Error Mapper → Domain Failure → Presentation Layer → UI Error Widget
```

1. **Data Layer**: Throws specific data exceptions with technical details
2. **Error Mapper**: Converts exceptions to domain failures
3. **Domain Layer**: Uses abstract failure types
4. **Presentation Layer**: Handles failures and provides UI states
5. **UI Layer**: Displays appropriate error messages and actions

## Testing

The error handling system is designed to be easily testable:

```dart
// Test specific failure types
test('should handle NetworkFailure correctly', () {
  final failure = NetworkFailure(
    message: 'No internet connection',
    code: 'NO_INTERNET_CONNECTION',
  );
  
  expect(failure.message, equals('No internet connection'));
  expect(failure.code, equals('NO_INTERNET_CONNECTION'));
});

// Test error mapper
test('should map DioException to appropriate failure', () {
  final dioException = DioException(
    requestOptions: RequestOptions(path: '/test'),
    type: DioExceptionType.connectionError,
  );
  
  final failure = ErrorMapper.mapExceptionToFailure(dioException);
  expect(failure, isA<NetworkFailure>());
});
```

## Future Enhancements

1. **Error Analytics**: Integration with crash reporting tools
2. **Retry Mechanisms**: Automatic retry logic for transient errors
3. **Error Caching**: Cache error states for offline scenarios
4. **Localization**: Multi-language error messages
5. **Error Recovery**: Automatic error recovery strategies

This error handling implementation provides a robust, scalable, and maintainable solution that follows Clean Architecture principles while providing excellent user experience and developer experience.