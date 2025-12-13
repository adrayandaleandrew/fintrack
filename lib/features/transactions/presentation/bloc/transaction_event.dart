import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

/// Base class for all transaction events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all transactions for a user
class LoadTransactions extends TransactionEvent {
  final String userId;

  const LoadTransactions({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event to load a specific transaction by ID
class LoadTransactionById extends TransactionEvent {
  final String transactionId;

  const LoadTransactionById({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

/// Event to create a new transaction
class CreateTransaction extends TransactionEvent {
  final Transaction transaction;

  const CreateTransaction({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

/// Event to update an existing transaction
class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;

  const UpdateTransaction({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

/// Event to delete a transaction
class DeleteTransaction extends TransactionEvent {
  final String transactionId;

  const DeleteTransaction({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

/// Event to filter transactions by criteria
class FilterTransactions extends TransactionEvent {
  final String userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? accountId;
  final String? categoryId;
  final TransactionType? type;

  const FilterTransactions({
    required this.userId,
    this.startDate,
    this.endDate,
    this.accountId,
    this.categoryId,
    this.type,
  });

  @override
  List<Object?> get props => [
        userId,
        startDate,
        endDate,
        accountId,
        categoryId,
        type,
      ];
}

/// Event to search transactions by query
class SearchTransactions extends TransactionEvent {
  final String userId;
  final String query;

  const SearchTransactions({
    required this.userId,
    required this.query,
  });

  @override
  List<Object?> get props => [userId, query];
}
