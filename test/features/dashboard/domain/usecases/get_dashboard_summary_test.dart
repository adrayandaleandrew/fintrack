import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/accounts/domain/entities/account.dart';
import 'package:finance_tracker/features/accounts/domain/repositories/account_repository.dart';
import 'package:finance_tracker/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:finance_tracker/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_dashboard_summary_test.mocks.dart';

@GenerateMocks([AccountRepository, TransactionRepository])
void main() {
  late GetDashboardSummary useCase;
  late MockAccountRepository mockAccountRepository;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockAccountRepository = MockAccountRepository();
    mockTransactionRepository = MockTransactionRepository();
    useCase = GetDashboardSummary(
      accountRepository: mockAccountRepository,
      transactionRepository: mockTransactionRepository,
    );
  });

  group('GetDashboardSummary', () {
    const tUserId = 'user_1';
    final tAccounts = [
      Account(
        id: 'acc_1',
        userId: tUserId,
        name: 'Checking',
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

    final tTransactions = [
      Transaction(
        id: 'txn_1',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.income,
        amount: 5000.0,
        currency: 'USD',
        description: 'Salary',
        date: DateTime(2025, 1, 15),
        createdAt: DateTime(2025, 1, 15),
        updatedAt: DateTime(2025, 1, 15),
      ),
      Transaction(
        id: 'txn_2',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_2',
        type: TransactionType.expense,
        amount: 200.0,
        currency: 'USD',
        description: 'Groceries',
        date: DateTime(2025, 1, 10),
        createdAt: DateTime(2025, 1, 10),
        updatedAt: DateTime(2025, 1, 10),
      ),
    ];

    test('should get dashboard summary successfully', () async {
      // Arrange
      when(mockAccountRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(tAccounts));

      when(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: TransactionType.income,
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => const Right(5000.0));

      when(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: TransactionType.expense,
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => const Right(1200.0));

      when(mockTransactionRepository.getTransactions(any))
          .thenAnswer((_) async => Right(tTransactions));

      when(mockTransactionRepository.getRecentTransactions(
        userId: anyNamed('userId'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => Right(tTransactions));

      // Act
      final result = await useCase(
        const GetDashboardSummaryParams(userId: tUserId),
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (summary) {
          expect(summary.totalBalance, 6000.0); // 1000 + 5000
          expect(summary.monthToDateIncome, 5000.0);
          expect(summary.monthToDateExpense, 1200.0);
          expect(summary.netChange, 3800.0); // 5000 - 1200
          expect(summary.accountCount, 2);
          expect(summary.transactionCount, 2);
          expect(summary.accounts, tAccounts);
          expect(summary.recentTransactions, tTransactions);
        },
      );

      verify(mockAccountRepository.getAccounts(
        userId: tUserId,
        activeOnly: true,
      ));
      verify(mockTransactionRepository.getTotalByType(
        userId: tUserId,
        type: TransactionType.income,
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ));
      verify(mockTransactionRepository.getTotalByType(
        userId: tUserId,
        type: TransactionType.expense,
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ));
      verify(mockTransactionRepository.getTransactions(tUserId));
      verify(mockTransactionRepository.getRecentTransactions(
        userId: tUserId,
        limit: 10,
      ));
    });

    test('should get dashboard summary with custom recent transactions limit', () async {
      // Arrange
      when(mockAccountRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(tAccounts));

      when(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: anyNamed('type'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => const Right(0.0));

      when(mockTransactionRepository.getTransactions(any))
          .thenAnswer((_) async => const Right([]));

      when(mockTransactionRepository.getRecentTransactions(
        userId: anyNamed('userId'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase(
        const GetDashboardSummaryParams(
          userId: tUserId,
          recentTransactionsLimit: 5,
        ),
      );

      // Assert
      expect(result.isRight(), true);
      verify(mockTransactionRepository.getRecentTransactions(
        userId: tUserId,
        limit: 5,
      ));
    });

    test('should get dashboard summary with empty accounts and transactions', () async {
      // Arrange
      when(mockAccountRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => const Right([]));

      when(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: anyNamed('type'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => const Right(0.0));

      when(mockTransactionRepository.getTransactions(any))
          .thenAnswer((_) async => const Right([]));

      when(mockTransactionRepository.getRecentTransactions(
        userId: anyNamed('userId'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase(
        const GetDashboardSummaryParams(userId: tUserId),
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (summary) {
          expect(summary.totalBalance, 0.0);
          expect(summary.monthToDateIncome, 0.0);
          expect(summary.monthToDateExpense, 0.0);
          expect(summary.netChange, 0.0);
          expect(summary.accountCount, 0);
          expect(summary.transactionCount, 0);
          expect(summary.accounts, []);
          expect(summary.recentTransactions, []);
        },
      );
    });

    test('should return failure when account repository fails', () async {
      // Arrange
      when(mockAccountRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to get accounts')));

      // Act
      final result = await useCase(
        const GetDashboardSummaryParams(userId: tUserId),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to get accounts')));
      verify(mockAccountRepository.getAccounts(
        userId: tUserId,
        activeOnly: true,
      ));
      verifyNever(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: anyNamed('type'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ));
    });

    test('should return failure when income fetch fails', () async {
      // Arrange
      when(mockAccountRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(tAccounts));

      when(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: TransactionType.income,
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to get income')));

      // Act
      final result = await useCase(
        const GetDashboardSummaryParams(userId: tUserId),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to get income')));
      verify(mockAccountRepository.getAccounts(
        userId: tUserId,
        activeOnly: true,
      ));
      verify(mockTransactionRepository.getTotalByType(
        userId: tUserId,
        type: TransactionType.income,
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ));
    });

    test('should return failure when expense fetch fails', () async {
      // Arrange
      when(mockAccountRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(tAccounts));

      when(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: TransactionType.income,
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => const Right(5000.0));

      when(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: TransactionType.expense,
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to get expenses')));

      // Act
      final result = await useCase(
        const GetDashboardSummaryParams(userId: tUserId),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to get expenses')));
    });

    test('should return failure when getTransactions fails', () async {
      // Arrange
      when(mockAccountRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(tAccounts));

      when(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: anyNamed('type'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => const Right(0.0));

      when(mockTransactionRepository.getTransactions(any))
          .thenAnswer((_) async => Left(ServerFailure('Failed to get transactions')));

      // Act
      final result = await useCase(
        const GetDashboardSummaryParams(userId: tUserId),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to get transactions')));
    });

    test('should return failure when getRecentTransactions fails', () async {
      // Arrange
      when(mockAccountRepository.getAccounts(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(tAccounts));

      when(mockTransactionRepository.getTotalByType(
        userId: anyNamed('userId'),
        type: anyNamed('type'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => const Right(0.0));

      when(mockTransactionRepository.getTransactions(any))
          .thenAnswer((_) async => Right(tTransactions));

      when(mockTransactionRepository.getRecentTransactions(
        userId: anyNamed('userId'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to get recent transactions')));

      // Act
      final result = await useCase(
        const GetDashboardSummaryParams(userId: tUserId),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to get recent transactions')));
    });
  });
}
