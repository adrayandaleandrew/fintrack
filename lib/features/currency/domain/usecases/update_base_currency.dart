import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/repositories/currency_repository.dart';

/// Use case for updating the user's base currency.
///
/// Updates the user's preferred currency for displaying financial data.
class UpdateBaseCurrency {
  final CurrencyRepository repository;

  UpdateBaseCurrency(this.repository);

  /// Executes the use case.
  ///
  /// Returns [Right(void)] on success or [Left(Failure)] on error.
  Future<Either<Failure, void>> call(UpdateBaseCurrencyParams params) async {
    // Validate currency code
    if (params.currencyCode.isEmpty || params.currencyCode.length != 3) {
      return Left(
        ValidationFailure('Invalid currency code: ${params.currencyCode}'),
      );
    }

    return await repository.updateBaseCurrency(
      userId: params.userId,
      currencyCode: params.currencyCode.toUpperCase(),
    );
  }
}

/// Parameters for UpdateBaseCurrency use case.
class UpdateBaseCurrencyParams extends Equatable {
  /// User ID
  final String userId;

  /// New currency code
  final String currencyCode;

  const UpdateBaseCurrencyParams({
    required this.userId,
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [userId, currencyCode];
}
