import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../entities/dashboard_summary.dart';

/// Use case for getting dashboard summary
///
/// Aggregates data from accounts and transactions repositories
/// to provide a comprehensive financial overview.
class GetDashboardSummary {
  final AccountRepository accountRepository;
  final TransactionRepository transactionRepository;

  GetDashboardSummary({
    required this.accountRepository,
    required this.transactionRepository,
  });

  /// Execute the use case
  ///
  /// Returns [DashboardSummary] with aggregated financial data
  /// Returns [Failure] if any data fetch fails
  Future<Either<Failure, DashboardSummary>> call(
    GetDashboardSummaryParams params,
  ) async {
    try {
      // Get all accounts
      final accountsResult = await accountRepository.getAccounts(
        userId: params.userId,
        activeOnly: true,
      );

      if (accountsResult.isLeft()) {
        return Left(
          accountsResult.fold((failure) => failure, (r) => throw Exception()),
        );
      }

      final accounts = accountsResult.getOrElse(() => []);

      // Calculate total balance from all accounts
      final totalBalance = accounts.fold<double>(
        0.0,
        (sum, account) => sum + account.balance,
      );

      // Get current month date range
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      // Get month-to-date income
      final incomeResult = await transactionRepository.getTotalByType(
        userId: params.userId,
        type: TransactionType.income,
        startDate: monthStart,
        endDate: monthEnd,
      );

      if (incomeResult.isLeft()) {
        return Left(
          incomeResult.fold((failure) => failure, (r) => throw Exception()),
        );
      }

      final monthToDateIncome = incomeResult.getOrElse(() => 0.0);

      // Get month-to-date expenses
      final expenseResult = await transactionRepository.getTotalByType(
        userId: params.userId,
        type: TransactionType.expense,
        startDate: monthStart,
        endDate: monthEnd,
      );

      if (expenseResult.isLeft()) {
        return Left(
          expenseResult.fold((failure) => failure, (r) => throw Exception()),
        );
      }

      final monthToDateExpense = expenseResult.getOrElse(() => 0.0);

      // Calculate net change
      final netChange = monthToDateIncome - monthToDateExpense;

      // Get all transactions for count
      final allTransactionsResult = await transactionRepository.getTransactions(
        params.userId,
      );

      if (allTransactionsResult.isLeft()) {
        return Left(
          allTransactionsResult.fold(
            (failure) => failure,
            (r) => throw Exception(),
          ),
        );
      }

      final allTransactions = allTransactionsResult.getOrElse(() => []);

      // Get recent transactions (last 10)
      final recentTransactionsResult =
          await transactionRepository.getRecentTransactions(
        userId: params.userId,
        limit: params.recentTransactionsLimit,
      );

      if (recentTransactionsResult.isLeft()) {
        return Left(
          recentTransactionsResult.fold(
            (failure) => failure,
            (r) => throw Exception(),
          ),
        );
      }

      final recentTransactions = recentTransactionsResult.getOrElse(() => []);

      // Create dashboard summary
      final summary = DashboardSummary(
        totalBalance: totalBalance,
        monthToDateIncome: monthToDateIncome,
        monthToDateExpense: monthToDateExpense,
        netChange: netChange,
        accountCount: accounts.length,
        transactionCount: allTransactions.length,
        accounts: accounts,
        recentTransactions: recentTransactions,
        lastUpdated: DateTime.now(),
      );

      return Right(summary);
    } catch (e) {
      return Left(UnexpectedFailure('Failed to load dashboard: $e'));
    }
  }
}

/// Parameters for GetDashboardSummary use case
class GetDashboardSummaryParams {
  final String userId;
  final int recentTransactionsLimit;

  const GetDashboardSummaryParams({
    required this.userId,
    this.recentTransactionsLimit = 10,
  });
}
