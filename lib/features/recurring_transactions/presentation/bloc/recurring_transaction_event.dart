import 'package:equatable/equatable.dart';
import '../../domain/entities/recurring_transaction.dart';

/// Base class for all recurring transaction events
abstract class RecurringTransactionEvent extends Equatable {
  const RecurringTransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all recurring transactions for a user
class LoadRecurringTransactions extends RecurringTransactionEvent {
  final String userId;
  final bool activeOnly;

  const LoadRecurringTransactions({
    required this.userId,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [userId, activeOnly];
}

/// Event to refresh recurring transactions
class RefreshRecurringTransactions extends RecurringTransactionEvent {
  final String userId;
  final bool activeOnly;

  const RefreshRecurringTransactions({
    required this.userId,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [userId, activeOnly];
}

/// Event to create a new recurring transaction
class CreateRecurringTransaction extends RecurringTransactionEvent {
  final RecurringTransaction recurringTransaction;

  const CreateRecurringTransaction({
    required this.recurringTransaction,
  });

  @override
  List<Object?> get props => [recurringTransaction];
}

/// Event to update an existing recurring transaction
class UpdateRecurringTransaction extends RecurringTransactionEvent {
  final RecurringTransaction recurringTransaction;

  const UpdateRecurringTransaction({
    required this.recurringTransaction,
  });

  @override
  List<Object?> get props => [recurringTransaction];
}

/// Event to delete a recurring transaction
class DeleteRecurringTransaction extends RecurringTransactionEvent {
  final String recurringTransactionId;

  const DeleteRecurringTransaction({
    required this.recurringTransactionId,
  });

  @override
  List<Object?> get props => [recurringTransactionId];
}

/// Event to process due recurring transactions
class ProcessDueRecurringTransactions extends RecurringTransactionEvent {
  const ProcessDueRecurringTransactions();
}

/// Event to toggle active status
class ToggleRecurringTransactionStatus extends RecurringTransactionEvent {
  final String recurringTransactionId;

  const ToggleRecurringTransactionStatus({
    required this.recurringTransactionId,
  });

  @override
  List<Object?> get props => [recurringTransactionId];
}
