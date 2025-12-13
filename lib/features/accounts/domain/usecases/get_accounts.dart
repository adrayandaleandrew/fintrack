import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

/// Get accounts use case
///
/// Retrieves all accounts for a user.
/// This is a single-responsibility class that handles only getting accounts.
class GetAccounts {
  final AccountRepository repository;

  const GetAccounts({required this.repository});

  /// Executes the get accounts use case
  ///
  /// Returns [Right(List<Account>)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, List<Account>>> call(GetAccountsParams params) async {
    return await repository.getAccounts(
      userId: params.userId,
      activeOnly: params.activeOnly,
    );
  }
}

/// Parameters for GetAccounts use case
class GetAccountsParams extends Equatable {
  final String userId;
  final bool activeOnly;

  const GetAccountsParams({
    required this.userId,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [userId, activeOnly];
}
