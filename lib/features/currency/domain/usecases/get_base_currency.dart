import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/repositories/currency_repository.dart';

/// Use case for getting the user's base currency.
///
/// The base currency is the user's preferred currency for displaying totals.
class GetBaseCurrency {
  final CurrencyRepository repository;

  GetBaseCurrency(this.repository);

  /// Executes the use case.
  ///
  /// Returns [Right(String)] currency code on success or [Left(Failure)] on error.
  Future<Either<Failure, String>> call(GetBaseCurrencyParams params) async {
    return await repository.getBaseCurrency(params.userId);
  }
}

/// Parameters for GetBaseCurrency use case.
class GetBaseCurrencyParams extends Equatable {
  /// User ID
  final String userId;

  const GetBaseCurrencyParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
