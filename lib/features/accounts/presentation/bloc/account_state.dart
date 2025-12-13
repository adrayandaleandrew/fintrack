import 'package:equatable/equatable.dart';
import '../../domain/entities/account.dart';

/// Base class for all account states
abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

/// Initial state when bloc is created
class AccountInitial extends AccountState {
  const AccountInitial();
}

/// Loading state for any account operation
class AccountLoading extends AccountState {
  const AccountLoading();
}

/// State when multiple accounts are loaded successfully
class AccountsLoaded extends AccountState {
  final List<Account> accounts;
  final bool activeOnly;

  const AccountsLoaded({
    required this.accounts,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [accounts, activeOnly];

  /// Helper to get accounts by type
  List<Account> getAccountsByType(AccountType type) {
    return accounts.where((account) => account.type == type).toList();
  }

  /// Helper to get total balance across all accounts
  double getTotalBalance({String? currency}) {
    if (currency != null) {
      return accounts
          .where((account) => account.currency == currency)
          .fold(0.0, (sum, account) => sum + account.balance);
    }
    return accounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  /// Helper to get active accounts
  List<Account> get activeAccounts {
    return accounts.where((account) => account.isActive).toList();
  }
}

/// State when a single account is loaded successfully
class AccountLoaded extends AccountState {
  final Account account;

  const AccountLoaded({required this.account});

  @override
  List<Object?> get props => [account];
}

/// State when an account action (create, update, delete) succeeds
class AccountActionSuccess extends AccountState {
  final String message;
  final Account? account; // For create/update operations

  const AccountActionSuccess({
    required this.message,
    this.account,
  });

  @override
  List<Object?> get props => [message, account];
}

/// State when total balance is loaded
class TotalBalanceLoaded extends AccountState {
  final double totalBalance;
  final String currency;
  final bool activeOnly;

  const TotalBalanceLoaded({
    required this.totalBalance,
    required this.currency,
    this.activeOnly = true,
  });

  @override
  List<Object?> get props => [totalBalance, currency, activeOnly];
}

/// State when an error occurs
class AccountError extends AccountState {
  final String message;

  const AccountError({required this.message});

  @override
  List<Object?> get props => [message];
}
