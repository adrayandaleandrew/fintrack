import 'package:equatable/equatable.dart';

/// Account entity
///
/// Represents a financial account in the domain layer.
/// This is a pure Dart class with no dependencies on external packages
/// (except Equatable for value equality).
///
/// Supports multiple account types: Bank, Cash, Credit Card, Investment.
class Account extends Equatable {
  /// Unique identifier
  final String id;

  /// User ID (owner of the account)
  final String userId;

  /// Account name (e.g., "Main Checking", "Savings", "Cash Wallet")
  final String name;

  /// Account type
  final AccountType type;

  /// Current balance
  final double balance;

  /// Currency code (e.g., 'USD', 'EUR', 'GBP')
  final String currency;

  /// Icon identifier (for UI display)
  final String icon;

  /// Color hex code (for UI display)
  final String color;

  /// Whether the account is active
  final bool isActive;

  /// Account creation timestamp
  final DateTime createdAt;

  /// Last updated timestamp
  final DateTime updatedAt;

  /// Optional notes/description
  final String? notes;

  /// Credit limit (only for credit card accounts)
  final double? creditLimit;

  /// Interest rate (for savings/investment accounts)
  final double? interestRate;

  const Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.creditLimit,
    this.interestRate,
  });

  /// Creates a copy of this account with updated fields
  Account copyWith({
    String? id,
    String? userId,
    String? name,
    AccountType? type,
    double? balance,
    String? currency,
    String? icon,
    String? color,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    double? creditLimit,
    double? interestRate,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      creditLimit: creditLimit ?? this.creditLimit,
      interestRate: interestRate ?? this.interestRate,
    );
  }

  /// Calculates available credit (for credit card accounts)
  double get availableCredit {
    if (type != AccountType.creditCard || creditLimit == null) {
      return 0.0;
    }
    return creditLimit! + balance; // balance is negative for credit cards
  }

  /// Checks if account has sufficient balance for a transaction
  bool hasSufficientBalance(double amount) {
    if (type == AccountType.creditCard) {
      return availableCredit >= amount;
    }
    return balance >= amount;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        type,
        balance,
        currency,
        icon,
        color,
        isActive,
        createdAt,
        updatedAt,
        notes,
        creditLimit,
        interestRate,
      ];

  @override
  bool get stringify => true;
}

/// Account type enum
enum AccountType {
  /// Bank account (checking, savings)
  bank,

  /// Cash account (physical cash, wallet)
  cash,

  /// Credit card account
  creditCard,

  /// Investment account (stocks, bonds, crypto)
  investment,
}

/// Extension for AccountType to get display names
extension AccountTypeExtension on AccountType {
  /// Returns human-readable name
  String get displayName {
    switch (this) {
      case AccountType.bank:
        return 'Bank Account';
      case AccountType.cash:
        return 'Cash';
      case AccountType.creditCard:
        return 'Credit Card';
      case AccountType.investment:
        return 'Investment';
    }
  }

  /// Returns icon name for the account type
  String get defaultIcon {
    switch (this) {
      case AccountType.bank:
        return 'account_balance';
      case AccountType.cash:
        return 'account_balance_wallet';
      case AccountType.creditCard:
        return 'credit_card';
      case AccountType.investment:
        return 'trending_up';
    }
  }
}
