import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

/// Get account by ID use case
///
/// Retrieves a single account by its ID.
/// This is a single-responsibility class that handles only getting one account.
class GetAccountById {
  final AccountRepository repository;

  const GetAccountById({required this.repository});

  /// Executes the get account by ID use case
  ///
  /// Returns [Right(Account)] on success
  /// Returns [Left(NotFoundFailure)] if account doesn't exist
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, Account>> call(GetAccountByIdParams params) async {
    return await repository.getAccountById(
      accountId: params.accountId,
    );
  }
}

/// Parameters for GetAccountById use case
class GetAccountByIdParams extends Equatable {
  final String accountId;

  const GetAccountByIdParams({required this.accountId});

  @override
  List<Object?> get props => [accountId];
}
