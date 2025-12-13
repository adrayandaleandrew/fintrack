import '../../domain/entities/account.dart';
import '../models/account_model.dart';

/// Account remote data source interface
///
/// Defines the contract for account API calls.
/// Implementations handle actual network requests (mock or real).
abstract class AccountRemoteDataSource {
  /// Gets all accounts for a user
  ///
  /// Returns [List<AccountModel>] on success
  /// Throws [ServerException] on API error
  /// Throws [NetworkException] on network error
  Future<List<AccountModel>> getAccounts({
    required String userId,
    bool activeOnly = false,
  });

  /// Gets a single account by ID
  ///
  /// Returns [AccountModel] on success
  /// Throws [NotFoundException] if account doesn't exist
  /// Throws [ServerException] on API error
  /// Throws [NetworkException] on network error
  Future<AccountModel> getAccountById({
    required String accountId,
  });

  /// Creates a new account
  ///
  /// Returns [AccountModel] on success with created account
  /// Throws [ValidationException] if validation fails
  /// Throws [ServerException] on API error
  /// Throws [NetworkException] on network error
  Future<AccountModel> createAccount({
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
  /// Returns [AccountModel] on success with updated account
  /// Throws [NotFoundException] if account doesn't exist
  /// Throws [ValidationException] if validation fails
  /// Throws [ServerException] on API error
  /// Throws [NetworkException] on network error
  Future<AccountModel> updateAccount({
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
  /// Returns nothing on success
  /// Throws [NotFoundException] if account doesn't exist
  /// Throws [ValidationException] if account has transactions
  /// Throws [ServerException] on API error
  /// Throws [NetworkException] on network error
  Future<void> deleteAccount({
    required String accountId,
  });

  /// Updates account balance
  ///
  /// Returns [AccountModel] on success with updated balance
  /// Throws [NotFoundException] if account doesn't exist
  /// Throws [ServerException] on API error
  /// Throws [NetworkException] on network error
  Future<AccountModel> updateBalance({
    required String accountId,
    required double newBalance,
  });
}
