/// Base class for all exceptions in the application.
///
/// Exceptions are thrown in the data layer and caught by repositories,
/// which then convert them to Failures for the domain layer.
class AppException implements Exception {
  final String message;
  final dynamic originalError;

  const AppException(this.message, [this.originalError]);

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when there's an issue with the server/remote data source.
///
/// This is typically caught by repositories and converted to ServerFailure.
///
/// Examples:
/// - HTTP error responses (4xx, 5xx)
/// - Network timeouts
/// - Invalid API responses
/// - Server is unreachable
class ServerException extends AppException {
  const ServerException(String message, [dynamic originalError])
      : super(message, originalError);

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when there's an issue with local cache/storage.
///
/// This is typically caught by repositories and converted to CacheFailure.
///
/// Examples:
/// - Failed to read from Hive database
/// - Failed to write to SharedPreferences
/// - Cache data is corrupted
/// - Storage permissions denied
class CacheException extends AppException {
  const CacheException(String message, [dynamic originalError])
      : super(message, originalError);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when there's no network connectivity.
///
/// This is typically caught by repositories and converted to NetworkFailure.
///
/// Examples:
/// - Device is offline
/// - Network request timed out
/// - DNS resolution failed
class NetworkException extends AppException {
  const NetworkException(String message, [dynamic originalError])
      : super(message, originalError);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when input validation fails.
///
/// This is typically caught by use cases or repositories and converted to ValidationFailure.
///
/// Examples:
/// - Email format is invalid
/// - Amount is zero or negative
/// - Required field is missing
/// - Date is out of valid range
class ValidationException extends AppException {
  const ValidationException(String message) : super(message);

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when authentication or authorization fails.
///
/// This is typically caught by repositories and converted to AuthFailure.
///
/// Examples:
/// - Invalid username or password
/// - Token has expired
/// - User doesn't have permission
/// - Session is invalid
class AuthException extends AppException {
  const AuthException(String message, [dynamic originalError])
      : super(message, originalError);

  @override
  String toString() => 'AuthException: $message';
}

/// Exception thrown when a requested resource is not found.
///
/// This is typically caught by repositories and converted to NotFoundFailure.
///
/// Examples:
/// - Account ID doesn't exist
/// - Transaction not found in database
/// - Category was deleted
class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message);

  @override
  String toString() => 'NotFoundException: $message';
}
