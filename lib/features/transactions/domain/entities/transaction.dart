import 'package:equatable/equatable.dart';

/// Transaction entity representing a financial transaction
///
/// Supports three types:
/// - Income: Money coming into an account
/// - Expense: Money going out of an account
/// - Transfer: Money moving between two accounts
class Transaction extends Equatable {
  /// Unique identifier
  final String id;

  /// User who owns this transaction
  final String userId;

  /// Source account ID (where money comes from for expense/transfer, or goes to for income)
  final String accountId;

  /// Category ID for classification
  final String categoryId;

  /// Transaction type
  final TransactionType type;

  /// Amount in the account's currency
  final double amount;

  /// Currency code (ISO 4217)
  final String currency;

  /// Brief description
  final String description;

  /// Transaction date
  final DateTime date;

  /// Additional notes (optional)
  final String? notes;

  /// Tags for filtering (optional)
  final List<String>? tags;

  /// Receipt/attachment URL (optional)
  final String? receiptUrl;

  /// Destination account ID (only for transfers)
  final String? toAccountId;

  /// When the transaction was created
  final DateTime createdAt;

  /// When the transaction was last updated
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    required this.date,
    this.notes,
    this.tags,
    this.receiptUrl,
    this.toAccountId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a copy with updated fields
  Transaction copyWith({
    String? id,
    String? userId,
    String? accountId,
    String? categoryId,
    TransactionType? type,
    double? amount,
    String? currency,
    String? description,
    DateTime? date,
    String? notes,
    List<String>? tags,
    String? receiptUrl,
    String? toAccountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      toAccountId: toAccountId ?? this.toAccountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Whether this is a transfer transaction
  bool get isTransfer => type == TransactionType.transfer;

  /// Whether this is an income transaction
  bool get isIncome => type == TransactionType.income;

  /// Whether this is an expense transaction
  bool get isExpense => type == TransactionType.expense;

  /// Formatted amount with sign (+ for income, - for expense)
  String get signedAmount {
    final sign = isIncome ? '+' : '-';
    return '$sign$amount';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        accountId,
        categoryId,
        type,
        amount,
        currency,
        description,
        date,
        notes,
        tags,
        receiptUrl,
        toAccountId,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Transaction(id: $id, type: ${type.displayName}, amount: $amount $currency, description: $description, date: $date)';
  }
}

/// Transaction type enum
enum TransactionType {
  /// Money coming in
  income,

  /// Money going out
  expense,

  /// Money moving between accounts
  transfer;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case TransactionType.income:
        return 'Income';
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }

  /// Icon name for UI
  String get iconName {
    switch (this) {
      case TransactionType.income:
        return 'arrow_downward'; // Money coming in
      case TransactionType.expense:
        return 'arrow_upward'; // Money going out
      case TransactionType.transfer:
        return 'swap_horiz'; // Money moving between accounts
    }
  }

  /// Color for UI
  String get colorHex {
    switch (this) {
      case TransactionType.income:
        return '#4CAF50'; // Green
      case TransactionType.expense:
        return '#F44336'; // Red
      case TransactionType.transfer:
        return '#2196F3'; // Blue
    }
  }

  /// Whether this type affects account balance positively
  bool get increasesBalance {
    return this == TransactionType.income;
  }

  /// Whether this type affects account balance negatively
  bool get decreasesBalance {
    return this == TransactionType.expense;
  }
}
