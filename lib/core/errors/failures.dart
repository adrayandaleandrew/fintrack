import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// Failures represent error states that can occur during business logic execution.
/// They are used in the Either<Failure, Success> pattern to handle errors gracefully.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure that occurs when there's an issue with the server/remote data source.
///
/// Examples:
/// - HTTP 500 errors
/// - API endpoint not found (404)
/// - Server timeout
/// - Invalid response format
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// Failure that occurs when there's an issue with local cache/storage.
///
/// Examples:
/// - Failed to read from Hive
/// - Failed to write to SharedPreferences
/// - Corrupted cache data
/// - Storage quota exceeded
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// Failure that occurs when there's no network connectivity.
///
/// Examples:
/// - Device is offline
/// - Airplane mode enabled
/// - Wi-Fi/mobile data disabled
/// - Network timeout
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

/// Failure that occurs when input validation fails.
///
/// Examples:
/// - Invalid email format
/// - Amount is zero or negative
/// - Required field is empty
/// - Date is in invalid range
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Failure that occurs when authentication or authorization fails.
///
/// Examples:
/// - Invalid credentials
/// - Token expired
/// - Unauthorized access attempt
/// - Missing authentication token
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

/// Failure that occurs when a requested resource is not found.
///
/// Examples:
/// - Account not found
/// - Transaction not found
/// - Category doesn't exist
class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message);
}

/// Generic failure for unexpected errors that don't fit other categories.
///
/// Examples:
/// - Unexpected null values
/// - Type casting errors
/// - Unhandled edge cases
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(String message) : super(message);
}
