import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/entities/currency.dart';
import 'package:finance_tracker/features/currency/domain/repositories/currency_repository.dart';
import 'package:finance_tracker/features/currency/domain/usecases/get_currencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_currencies_test.mocks.dart';

@GenerateMocks([CurrencyRepository])
void main() {
  late GetCurrencies useCase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    useCase = GetCurrencies(mockRepository);
  });

  group('GetCurrencies', () {
    final tCurrencies = [
      const Currency(
        code: 'USD',
        name: 'US Dollar',
        symbol: '\$',
        decimalPlaces: 2,
        flag: '🇺🇸',
      ),
      const Currency(
        code: 'EUR',
        name: 'Euro',
        symbol: '€',
        decimalPlaces: 2,
        flag: '🇪🇺',
      ),
    ];

    test('should get list of currencies from repository', () async {
      // Arrange
      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => Right(tCurrencies));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(tCurrencies));
      verify(mockRepository.getCurrencies());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => Left(ServerFailure('Server error')));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Left(ServerFailure('Server error')));
      verify(mockRepository.getCurrencies());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => Left(CacheFailure('Cache error')));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Left(CacheFailure('Cache error')));
      verify(mockRepository.getCurrencies());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
