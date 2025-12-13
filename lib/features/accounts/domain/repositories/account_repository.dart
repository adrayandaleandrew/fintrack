import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/account.dart';

/// Account repository interface
///
/// Defines the contract for account operations.
/// Implementations will handle actual data operations (mock or real API).
abstract class AccountRepository {
  /// Gets all accounts for a user
  ///
  /// Returns [Right(List<Account>)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, List<Account>>> getAccounts({
    required String userId,
    bool activeOnly = false,
  });

  /// Gets a single account by ID
  ///
  /// Returns [Right(Account)] on success
  /// Returns [Left(NotFoundFailure)] if account doesn't exist
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, Account>> getAccountById({
    required String accountId,
  });

  /// Creates a new account
  ///
  /// Returns [Right(Account)] on success with created account
  /// Returns [Left(ValidationFailure)] if validation fails
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, Account>> createAccount({
    required String userId,
    required String name,
    required AccountType type,
    required double initialBalance,
    required String currency,
    String? icon,
    String? color,
    String? notes,
    double? creditLimit,
    double? interestRate,
  });

  /// Updates an existing account
  ///
  /// Returns [Right(Account)] on success with updated account
  /// Returns [Left(NotFoundFailure)] if account doesn't exist
  /// Returns [Left(ValidationFailure)] if validation fails
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, Account>> updateAccount({
    required String accountId,
    String? name,
    AccountType? type,
    String? currency,
    String? icon,
    String? color,
    bool? isActive,
    String? notes,
    double? creditLimit,
    double? interestRate,
  });

  /// Deletes an account
  ///
  /// Note: Should check if account has transactions before deleting
  ///
  /// Returns [Right(void)] on success
  /// Returns [Left(NotFoundFailure)] if account doesn't exist
  /// Returns [Left(ValidationFailure)] if account has transactions
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, void>> deleteAccount({
    required String accountId,
  });

  /// Updates account balance (used by transactions)
  ///
  /// Returns [Right(Account)] on success with updated account
  /// Returns [Left(NotFoundFailure)] if account doesn't exist
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, Account>> updateBalance({
    required String accountId,
    required double newBalance,
  });

  /// Gets total balance across all accounts in a specific currency
  ///
  /// Returns [Right(double)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, double>> getTotalBalance({
    required String userId,
    required String currency,
    bool activeOnly = true,
  });
}
