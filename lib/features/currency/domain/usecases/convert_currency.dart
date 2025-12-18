import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/repositories/currency_repository.dart';

/// Use case for converting currency amounts.
///
/// Converts an amount from one currency to another using current exchange rates.
class ConvertCurrency {
  final CurrencyRepository repository;

  ConvertCurrency(this.repository);

  /// Executes the use case.
  ///
  /// Returns [Right(double)] converted amount on success or [Left(Failure)] on error.
  Future<Either<Failure, double>> call(ConvertCurrencyParams params) async {
    // Validate amount
    if (params.amount < 0) {
      return Left(ValidationFailure('Amount cannot be negative'));
    }

    // Same currency, no conversion needed
    if (params.fromCurrency == params.toCurrency) {
      return Right(params.amount);
    }

    return await repository.convertCurrency(
      amount: params.amount,
      fromCurrency: params.fromCurrency,
      toCurrency: params.toCurrency,
    );
  }
}

/// Parameters for ConvertCurrency use case.
class ConvertCurrencyParams extends Equatable {
  /// Amount to convert
  final double amount;

  /// Source currency code
  final String fromCurrency;

  /// Target currency code
  final String toCurrency;

  const ConvertCurrencyParams({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
  });

  @override
  List<Object?> get props => [amount, fromCurrency, toCurrency];
}
