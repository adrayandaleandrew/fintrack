import 'package:equatable/equatable.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../transactions/domain/entities/transaction.dart';

/// Dashboard summary entity
///
/// Aggregates data from multiple features to provide
/// a comprehensive overview of the user's financial status.
class DashboardSummary extends Equatable {
  final double totalBalance;
  final double monthToDateIncome;
  final double monthToDateExpense;
  final double netChange;
  final int accountCount;
  final int transactionCount;
  final List<Account> accounts;
  final List<Transaction> recentTransactions;
  final DateTime lastUpdated;

  const DashboardSummary({
    required this.totalBalance,
    required this.monthToDateIncome,
    required this.monthToDateExpense,
    required this.netChange,
    required this.accountCount,
    required this.transactionCount,
    required this.accounts,
    required this.recentTransactions,
    required this.lastUpdated,
  });

  /// Check if user has positive net change
  bool get hasPositiveNetChange => netChange >= 0;

  /// Get month-to-date savings rate (percentage)
  double get savingsRate {
    if (monthToDateIncome == 0) return 0;
    return (netChange / monthToDateIncome) * 100;
  }

  /// Check if user has any accounts
  bool get hasAccounts => accountCount > 0;

  /// Check if user has any transactions
  bool get hasTransactions => transactionCount > 0;

  @override
  List<Object?> get props => [
        totalBalance,
        monthToDateIncome,
        monthToDateExpense,
        netChange,
        accountCount,
        transactionCount,
        accounts,
        recentTransactions,
        lastUpdated,
      ];
}
