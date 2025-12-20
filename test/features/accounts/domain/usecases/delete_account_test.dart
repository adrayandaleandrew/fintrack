import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/accounts/domain/repositories/account_repository.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/delete_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_account_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late DeleteAccount useCase;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    useCase = DeleteAccount(repository: mockRepository);
  });

  group('DeleteAccount', () {
    const tAccountId = 'acc_1';

    test('should delete account successfully', () async {
      // Arrange
      when(mockRepository.deleteAccount(accountId: anyNamed('accountId')))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(const DeleteAccountParams(accountId: tAccountId));

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.deleteAccount(accountId: tAccountId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when account does not exist', () async {
      // Arrange
      when(mockRepository.deleteAccount(accountId: anyNamed('accountId')))
          .thenAnswer((_) async => Left(NotFoundFailure('Account not found')));

      // Act
      final result = await useCase(const DeleteAccountParams(accountId: tAccountId));

      // Assert
      expect(result, Left(NotFoundFailure('Account not found')));
      verify(mockRepository.deleteAccount(accountId: tAccountId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when account has transactions', () async {
      // Arrange
      when(mockRepository.deleteAccount(accountId: anyNamed('accountId')))
          .thenAnswer((_) async => Left(ValidationFailure(
              'Cannot delete account with existing transactions')));

      // Act
      final result = await useCase(const DeleteAccountParams(accountId: tAccountId));

      // Assert
      expect(result, Left(ValidationFailure(
          'Cannot delete account with existing transactions')));
      verify(mockRepository.deleteAccount(accountId: tAccountId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.deleteAccount(accountId: anyNamed('accountId')))
          .thenAnswer((_) async => Left(ServerFailure('Failed to delete account')));

      // Act
      final result = await useCase(const DeleteAccountParams(accountId: tAccountId));

      // Assert
      expect(result, Left(ServerFailure('Failed to delete account')));
      verify(mockRepository.deleteAccount(accountId: tAccountId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.deleteAccount(accountId: anyNamed('accountId')))
          .thenAnswer((_) async => Left(CacheFailure('Failed to delete from cache')));

      // Act
      final result = await useCase(const DeleteAccountParams(accountId: tAccountId));

      // Assert
      expect(result, Left(CacheFailure('Failed to delete from cache')));
      verify(mockRepository.deleteAccount(accountId: tAccountId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
