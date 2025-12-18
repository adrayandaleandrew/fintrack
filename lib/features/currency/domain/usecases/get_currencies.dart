import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/entities/currency.dart';
import 'package:finance_tracker/features/currency/domain/repositories/currency_repository.dart';

/// Use case for getting all supported currencies.
///
/// Returns a list of all available currencies in the system.
class GetCurrencies {
  final CurrencyRepository repository;

  GetCurrencies(this.repository);

  /// Executes the use case.
  ///
  /// Returns [Right(List<Currency>)] on success or [Left(Failure)] on error.
  Future<Either<Failure, List<Currency>>> call() async {
    return await repository.getCurrencies();
  }
}
