import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

/// Base class for all transaction states
abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

/// Initial state when BLoC is created
class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

/// State when transactions are being loaded
class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

/// State when transactions are successfully loaded
class TransactionsLoaded extends TransactionState {
  final List<Transaction> transactions;

  const TransactionsLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

/// State when a single transaction is successfully loaded
class TransactionLoaded extends TransactionState {
  final Transaction transaction;

  const TransactionLoaded({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

/// State when a transaction action is in progress (create, update, delete)
class TransactionActionInProgress extends TransactionState {
  const TransactionActionInProgress();
}

/// State when a transaction action succeeds
class TransactionActionSuccess extends TransactionState {
  final String message;
  final Transaction? transaction;

  const TransactionActionSuccess({
    required this.message,
    this.transaction,
  });

  @override
  List<Object?> get props => [message, transaction];
}

/// State when a transaction operation fails
class TransactionError extends TransactionState {
  final String message;

  const TransactionError({required this.message});

  @override
  List<Object?> get props => [message];
}
