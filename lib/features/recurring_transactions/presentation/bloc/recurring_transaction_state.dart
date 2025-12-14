import 'package:equatable/equatable.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/recurring_transaction.dart';

/// Base class for all recurring transaction states
abstract class RecurringTransactionState extends Equatable {
  const RecurringTransactionState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any recurring transactions are loaded
class RecurringTransactionInitial extends RecurringTransactionState {
  const RecurringTransactionInitial();
}

/// Loading state when fetching recurring transactions
class RecurringTransactionLoading extends RecurringTransactionState {
  const RecurringTransactionLoading();
}

/// State when recurring transactions are successfully loaded
class RecurringTransactionsLoaded extends RecurringTransactionState {
  final List<RecurringTransaction> recurringTransactions;

  const RecurringTransactionsLoaded({
    required this.recurringTransactions,
  });

  @override
  List<Object?> get props => [recurringTransactions];

  /// Get active recurring transactions
  List<RecurringTransaction> get activeRecurringTransactions {
    return recurringTransactions.where((r) => r.isCurrentlyActive).toList();
  }

  /// Get due recurring transactions
  List<RecurringTransaction> get dueRecurringTransactions {
    return recurringTransactions.where((r) => r.isDue()).toList();
  }

  /// Get upcoming recurring transactions (next 7 days)
  List<RecurringTransaction> get upcomingRecurringTransactions {
    final sevenDaysFromNow = DateTime.now().add(const Duration(days: 7));
    return recurringTransactions.where((r) {
      final nextOccurrence = r.getNextOccurrence();
      if (nextOccurrence == null) return false;
      return nextOccurrence.isBefore(sevenDaysFromNow);
    }).toList();
  }
}

/// State when a recurring transaction action was successful
class RecurringTransactionActionSuccess extends RecurringTransactionState {
  final String message;

  const RecurringTransactionActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when transactions were generated from recurring transactions
class TransactionsGenerated extends RecurringTransactionState {
  final List<Transaction> generatedTransactions;
  final String message;

  const TransactionsGenerated({
    required this.generatedTransactions,
    required this.message,
  });

  @override
  List<Object?> get props => [generatedTransactions, message];
}

/// Error state when something goes wrong
class RecurringTransactionError extends RecurringTransactionState {
  final String message;

  const RecurringTransactionError({required this.message});

  @override
  List<Object?> get props => [message];
}
