import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/entities/exchange_rate.dart';
import 'package:finance_tracker/features/currency/domain/repositories/currency_repository.dart';

/// Use case for getting exchange rates.
///
/// Optionally filters by base currency.
class GetExchangeRates {
  final CurrencyRepository repository;

  GetExchangeRates(this.repository);

  /// Executes the use case.
  ///
  /// Returns [Right(List<ExchangeRate>)] on success or [Left(Failure)] on error.
  Future<Either<Failure, List<ExchangeRate>>> call(
    GetExchangeRatesParams params,
  ) async {
    return await repository.getExchangeRates(
      baseCurrency: params.baseCurrency,
    );
  }
}

/// Parameters for GetExchangeRates use case.
class GetExchangeRatesParams extends Equatable {
  /// Optional base currency to filter rates
  final String? baseCurrency;

  const GetExchangeRatesParams({this.baseCurrency});

  @override
  List<Object?> get props => [baseCurrency];
}
