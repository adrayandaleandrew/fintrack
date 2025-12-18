import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/repositories/currency_repository.dart';
import 'package:finance_tracker/features/currency/domain/usecases/convert_currency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'convert_currency_test.mocks.dart';

@GenerateMocks([CurrencyRepository])
void main() {
  late ConvertCurrency useCase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    useCase = ConvertCurrency(mockRepository);
  });

  group('ConvertCurrency', () {
    const tAmount = 100.0;
    const tFromCurrency = 'USD';
    const tToCurrency = 'EUR';
    const tConvertedAmount = 92.0;

    test('should convert amount between different currencies', () async {
      // Arrange
      when(mockRepository.convertCurrency(
        amount: anyNamed('amount'),
        fromCurrency: anyNamed('fromCurrency'),
        toCurrency: anyNamed('toCurrency'),
      )).thenAnswer((_) async => const Right(tConvertedAmount));

      // Act
      final result = await useCase(const ConvertCurrencyParams(
        amount: tAmount,
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
      ));

      // Assert
      expect(result, const Right(tConvertedAmount));
      verify(mockRepository.convertCurrency(
        amount: tAmount,
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return same amount when converting to same currency',
        () async {
      // Act
      final result = await useCase(const ConvertCurrencyParams(
        amount: tAmount,
        fromCurrency: tFromCurrency,
        toCurrency: tFromCurrency,
      ));

      // Assert
      expect(result, const Right(tAmount));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is negative', () async {
      // Act
      final result = await useCase(const ConvertCurrencyParams(
        amount: -10.0,
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
      ));

      // Assert
      expect(result, Left(ValidationFailure('Amount cannot be negative')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.convertCurrency(
        amount: anyNamed('amount'),
        fromCurrency: anyNamed('fromCurrency'),
        toCurrency: anyNamed('toCurrency'),
      )).thenAnswer((_) async => Left(ServerFailure('Conversion failed')));

      // Act
      final result = await useCase(const ConvertCurrencyParams(
        amount: tAmount,
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
      ));

      // Assert
      expect(result, Left(ServerFailure('Conversion failed')));
      verify(mockRepository.convertCurrency(
        amount: tAmount,
        fromCurrency: tFromCurrency,
        toCurrency: tToCurrency,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
