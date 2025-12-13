import 'package:equatable/equatable.dart';
import '../../domain/entities/account.dart';

/// Base class for all account events
abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all accounts for a user
class LoadAccounts extends AccountEvent {
  final String userId;
  final bool activeOnly;

  const LoadAccounts({
    required this.userId,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [userId, activeOnly];
}

/// Event to load a single account by ID
class LoadAccountById extends AccountEvent {
  final String accountId;

  const LoadAccountById({required this.accountId});

  @override
  List<Object?> get props => [accountId];
}

/// Event to create a new account
class CreateAccountRequested extends AccountEvent {
  final String userId;
  final String name;
  final AccountType type;
  final double initialBalance;
  final String currency;
  final String? icon;
  final String? color;
  final String? notes;
  final double? creditLimit;
  final double? interestRate;

  const CreateAccountRequested({
    required this.userId,
    required this.name,
    required this.type,
    required this.initialBalance,
    required this.currency,
    this.icon,
    this.color,
    this.notes,
    this.creditLimit,
    this.interestRate,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        type,
        initialBalance,
        currency,
        icon,
        color,
        notes,
        creditLimit,
        interestRate,
      ];
}

/// Event to update an existing account
class UpdateAccountRequested extends AccountEvent {
  final String accountId;
  final String? name;
  final AccountType? type;
  final String? currency;
  final String? icon;
  final String? color;
  final bool? isActive;
  final String? notes;
  final double? creditLimit;
  final double? interestRate;

  const UpdateAccountRequested({
    required this.accountId,
    this.name,
    this.type,
    this.currency,
    this.icon,
    this.color,
    this.isActive,
    this.notes,
    this.creditLimit,
    this.interestRate,
  });

  @override
  List<Object?> get props => [
        accountId,
        name,
        type,
        currency,
        icon,
        color,
        isActive,
        notes,
        creditLimit,
        interestRate,
      ];
}

/// Event to delete an account
class DeleteAccountRequested extends AccountEvent {
  final String accountId;

  const DeleteAccountRequested({required this.accountId});

  @override
  List<Object?> get props => [accountId];
}

/// Event to get total balance
class GetTotalBalanceRequested extends AccountEvent {
  final String userId;
  final String currency;
  final bool activeOnly;

  const GetTotalBalanceRequested({
    required this.userId,
    required this.currency,
    this.activeOnly = true,
  });

  @override
  List<Object?> get props => [userId, currency, activeOnly];
}
