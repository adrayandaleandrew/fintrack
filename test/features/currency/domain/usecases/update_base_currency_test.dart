import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/repositories/currency_repository.dart';
import 'package:finance_tracker/features/currency/domain/usecases/update_base_currency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_base_currency_test.mocks.dart';

@GenerateMocks([CurrencyRepository])
void main() {
  late UpdateBaseCurrency useCase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    useCase = UpdateBaseCurrency(mockRepository);
  });

  group('UpdateBaseCurrency', () {
    const tUserId = 'user_1';
    const tCurrencyCode = 'EUR';

    test('should update base currency successfully', () async {
      // Arrange
      when(mockRepository.updateBaseCurrency(
        userId: anyNamed('userId'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(const UpdateBaseCurrencyParams(
        userId: tUserId,
        currencyCode: tCurrencyCode,
      ));

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.updateBaseCurrency(
        userId: tUserId,
        currencyCode: 'EUR', // Should be uppercase
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should convert currency code to uppercase', () async {
      // Arrange
      when(mockRepository.updateBaseCurrency(
        userId: anyNamed('userId'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(const UpdateBaseCurrencyParams(
        userId: tUserId,
        currencyCode: 'eur', // lowercase
      ));

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.updateBaseCurrency(
        userId: tUserId,
        currencyCode: 'EUR', // Should be converted to uppercase
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when currency code is empty',
        () async {
      // Act
      final result = await useCase(const UpdateBaseCurrencyParams(
        userId: tUserId,
        currencyCode: '',
      ));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when currency code is invalid length',
        () async {
      // Act
      final result = await useCase(const UpdateBaseCurrencyParams(
        userId: tUserId,
        currencyCode: 'US', // Only 2 characters
      ));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.updateBaseCurrency(
        userId: anyNamed('userId'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Left(ServerFailure('Update failed')));

      // Act
      final result = await useCase(const UpdateBaseCurrencyParams(
        userId: tUserId,
        currencyCode: tCurrencyCode,
      ));

      // Assert
      expect(result, Left(ServerFailure('Update failed')));
      verify(mockRepository.updateBaseCurrency(
        userId: tUserId,
        currencyCode: 'EUR',
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
