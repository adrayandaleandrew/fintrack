import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/accounts/domain/entities/account.dart';
import 'package:finance_tracker/features/accounts/domain/repositories/account_repository.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/get_account_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_account_by_id_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late GetAccountById useCase;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    useCase = GetAccountById(repository: mockRepository);
  });

  group('GetAccountById', () {
    const tAccountId = 'acc_1';
    final tAccount = Account(
      id: tAccountId,
      userId: 'user_1',
      name: 'Checking Account',
      type: AccountType.bank,
      balance: 1000.0,
      currency: 'USD',
      icon: 'account_balance',
      color: '#2196F3',
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    test('should get account by ID from repository', () async {
      // Arrange
      when(mockRepository.getAccountById(accountId: anyNamed('accountId')))
          .thenAnswer((_) async => Right(tAccount));

      // Act
      final result = await useCase(const GetAccountByIdParams(accountId: tAccountId));

      // Assert
      expect(result, Right(tAccount));
      verify(mockRepository.getAccountById(accountId: tAccountId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when account does not exist', () async {
      // Arrange
      when(mockRepository.getAccountById(accountId: anyNamed('accountId')))
          .thenAnswer((_) async => Left(NotFoundFailure('Account not found')));

      // Act
      final result = await useCase(const GetAccountByIdParams(accountId: tAccountId));

      // Assert
      expect(result, Left(NotFoundFailure('Account not found')));
      verify(mockRepository.getAccountById(accountId: tAccountId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getAccountById(accountId: anyNamed('accountId')))
          .thenAnswer((_) async => Left(ServerFailure('Failed to get account')));

      // Act
      final result = await useCase(const GetAccountByIdParams(accountId: tAccountId));

      // Assert
      expect(result, Left(ServerFailure('Failed to get account')));
      verify(mockRepository.getAccountById(accountId: tAccountId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.getAccountById(accountId: anyNamed('accountId')))
          .thenAnswer((_) async => Left(CacheFailure('Failed to load from cache')));

      // Act
      final result = await useCase(const GetAccountByIdParams(accountId: tAccountId));

      // Assert
      expect(result, Left(CacheFailure('Failed to load from cache')));
      verify(mockRepository.getAccountById(accountId: tAccountId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
