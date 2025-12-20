import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/accounts/domain/entities/account.dart';
import 'package:finance_tracker/features/accounts/domain/repositories/account_repository.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/get_accounts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_accounts_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late GetAccounts useCase;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    useCase = GetAccounts(repository: mockRepository);
  });

  group('GetAccounts', () {
    const tUserId = 'user_1';
    final tAccounts = [
      Account(
        id: 'acc_1',
        userId: tUserId,
        name: 'Checking Account',
        type: AccountType.bank,
        balance: 1000.0,
        currency: 'USD',
        icon: 'account_balance',
        color: '#2196F3',
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      ),
      Account(
        id: 'acc_2',
        userId: tUserId,
        name: 'Savings',
        type: AccountType.bank,
        balance: 5000.0,
        currency: 'USD',
        icon: 'savings',
        color: '#4CAF50',
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      ),
    ];

    test('should get list of accounts from repository', () async {
      // Arrange
      when(mockRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(tAccounts));

      // Act
      final result = await useCase(const GetAccountsParams(userId: tUserId));

      // Assert
      expect(result, Right(tAccounts));
      verify(mockRepository.getAccounts(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get only active accounts when activeOnly is true', () async {
      // Arrange
      final activeAccounts = [tAccounts.first];
      when(mockRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(activeAccounts));

      // Act
      final result = await useCase(
        const GetAccountsParams(userId: tUserId, activeOnly: true),
      );

      // Assert
      expect(result, Right(activeAccounts));
      verify(mockRepository.getAccounts(
        userId: tUserId,
        activeOnly: true,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no accounts exist', () async {
      // Arrange
      when(mockRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase(const GetAccountsParams(userId: tUserId));

      // Assert
      expect(result, const Right<Failure, List<Account>>([]));

      verify(mockRepository.getAccounts(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to get accounts')));

      // Act
      final result = await useCase(const GetAccountsParams(userId: tUserId));

      // Assert
      expect(result, Left(ServerFailure('Failed to get accounts')));
      verify(mockRepository.getAccounts(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Left(CacheFailure('Failed to load from cache')));

      // Act
      final result = await useCase(const GetAccountsParams(userId: tUserId));

      // Assert
      expect(result, Left(CacheFailure('Failed to load from cache')));
      verify(mockRepository.getAccounts(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
