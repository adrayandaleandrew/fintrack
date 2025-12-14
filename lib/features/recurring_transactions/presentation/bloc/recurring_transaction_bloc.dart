import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_recurring_transactions.dart';
import '../../domain/usecases/create_recurring_transaction.dart' as usecases;
import '../../domain/usecases/update_recurring_transaction.dart' as usecases;
import '../../domain/usecases/delete_recurring_transaction.dart' as usecases;
import '../../domain/usecases/process_due_recurring_transactions.dart' as usecases;
import 'recurring_transaction_event.dart';
import 'recurring_transaction_state.dart';

/// BLoC for managing recurring transaction state
///
/// Handles recurring transaction CRUD operations and auto-generation.
class RecurringTransactionBloc
    extends Bloc<RecurringTransactionEvent, RecurringTransactionState> {
  final GetRecurringTransactions getRecurringTransactions;
  final usecases.CreateRecurringTransaction createRecurringTransaction;
  final usecases.UpdateRecurringTransaction updateRecurringTransaction;
  final usecases.DeleteRecurringTransaction deleteRecurringTransaction;
  final usecases.ProcessDueRecurringTransactions processDueRecurringTransactions;

  RecurringTransactionBloc({
    required this.getRecurringTransactions,
    required this.createRecurringTransaction,
    required this.updateRecurringTransaction,
    required this.deleteRecurringTransaction,
    required this.processDueRecurringTransactions,
  }) : super(const RecurringTransactionInitial()) {
    on<LoadRecurringTransactions>(_onLoadRecurringTransactions);
    on<RefreshRecurringTransactions>(_onRefreshRecurringTransactions);
    on<CreateRecurringTransaction>(_onCreateRecurringTransaction);
    on<UpdateRecurringTransaction>(_onUpdateRecurringTransaction);
    on<DeleteRecurringTransaction>(_onDeleteRecurringTransaction);
    on<ProcessDueRecurringTransactions>(_onProcessDueRecurringTransactions);
    on<ToggleRecurringTransactionStatus>(_onToggleRecurringTransactionStatus);
  }

  /// Load all recurring transactions for a user
  Future<void> _onLoadRecurringTransactions(
    LoadRecurringTransactions event,
    Emitter<RecurringTransactionState> emit,
  ) async {
    emit(const RecurringTransactionLoading());

    final result = await getRecurringTransactions(
      GetRecurringTransactionsParams(
        userId: event.userId,
        activeOnly: event.activeOnly,
      ),
    );

    result.fold(
      (failure) => emit(RecurringTransactionError(message: failure.message)),
      (recurringTransactions) => emit(
        RecurringTransactionsLoaded(
          recurringTransactions: recurringTransactions,
        ),
      ),
    );
  }

  /// Refresh recurring transactions without showing loading state
  Future<void> _onRefreshRecurringTransactions(
    RefreshRecurringTransactions event,
    Emitter<RecurringTransactionState> emit,
  ) async {
    final result = await getRecurringTransactions(
      GetRecurringTransactionsParams(
        userId: event.userId,
        activeOnly: event.activeOnly,
      ),
    );

    result.fold(
      (failure) => emit(RecurringTransactionError(message: failure.message)),
      (recurringTransactions) => emit(
        RecurringTransactionsLoaded(
          recurringTransactions: recurringTransactions,
        ),
      ),
    );
  }

  /// Create a new recurring transaction
  Future<void> _onCreateRecurringTransaction(
    CreateRecurringTransaction event,
    Emitter<RecurringTransactionState> emit,
  ) async {
    final currentState = state;

    final result = await createRecurringTransaction(
      usecases.CreateRecurringTransactionParams(
        recurringTransaction: event.recurringTransaction,
      ),
    );

    result.fold(
      (failure) => emit(RecurringTransactionError(message: failure.message)),
      (recurringTransaction) {
        emit(
          const RecurringTransactionActionSuccess(
            message: 'Recurring transaction created successfully',
          ),
        );

        // Reload recurring transactions if we were in a loaded state
        if (currentState is RecurringTransactionsLoaded) {
          add(LoadRecurringTransactions(userId: recurringTransaction.userId));
        }
      },
    );
  }

  /// Update an existing recurring transaction
  Future<void> _onUpdateRecurringTransaction(
    UpdateRecurringTransaction event,
    Emitter<RecurringTransactionState> emit,
  ) async {
    final currentState = state;

    final result = await updateRecurringTransaction(
      usecases.UpdateRecurringTransactionParams(
        recurringTransaction: event.recurringTransaction,
      ),
    );

    result.fold(
      (failure) => emit(RecurringTransactionError(message: failure.message)),
      (recurringTransaction) {
        emit(
          const RecurringTransactionActionSuccess(
            message: 'Recurring transaction updated successfully',
          ),
        );

        // Reload recurring transactions if we were in a loaded state
        if (currentState is RecurringTransactionsLoaded) {
          add(LoadRecurringTransactions(userId: recurringTransaction.userId));
        }
      },
    );
  }

  /// Delete a recurring transaction
  Future<void> _onDeleteRecurringTransaction(
    DeleteRecurringTransaction event,
    Emitter<RecurringTransactionState> emit,
  ) async {
    final currentState = state;

    final result = await deleteRecurringTransaction(
      usecases.DeleteRecurringTransactionParams(
        recurringTransactionId: event.recurringTransactionId,
      ),
    );

    result.fold(
      (failure) => emit(RecurringTransactionError(message: failure.message)),
      (_) {
        emit(
          const RecurringTransactionActionSuccess(
            message: 'Recurring transaction deleted successfully',
          ),
        );

        // Remove from current state if we were in a loaded state
        if (currentState is RecurringTransactionsLoaded) {
          final recurringTransactions = currentState.recurringTransactions
              .where((r) => r.id != event.recurringTransactionId)
              .toList();
          emit(
            RecurringTransactionsLoaded(
              recurringTransactions: recurringTransactions,
            ),
          );
        }
      },
    );
  }

  /// Process due recurring transactions
  Future<void> _onProcessDueRecurringTransactions(
    ProcessDueRecurringTransactions event,
    Emitter<RecurringTransactionState> emit,
  ) async {
    final result = await processDueRecurringTransactions();

    result.fold(
      (failure) => emit(RecurringTransactionError(message: failure.message)),
      (generatedTransactions) {
        if (generatedTransactions.isEmpty) {
          emit(
            const RecurringTransactionActionSuccess(
              message: 'No due recurring transactions to process',
            ),
          );
        } else {
          emit(
            TransactionsGenerated(
              generatedTransactions: generatedTransactions,
              message:
                  '${generatedTransactions.length} transaction(s) generated from recurring templates',
            ),
          );
        }
      },
    );
  }

  /// Toggle active status of a recurring transaction
  Future<void> _onToggleRecurringTransactionStatus(
    ToggleRecurringTransactionStatus event,
    Emitter<RecurringTransactionState> emit,
  ) async {
    final currentState = state;

    if (currentState is! RecurringTransactionsLoaded) {
      return;
    }

    // Find the recurring transaction
    final recurring = currentState.recurringTransactions.firstWhere(
      (r) => r.id == event.recurringTransactionId,
    );

    // Toggle status
    final updated = recurring.copyWith(isActive: !recurring.isActive);

    // Update
    final result = await updateRecurringTransaction(
      usecases.UpdateRecurringTransactionParams(
        recurringTransaction: updated,
      ),
    );

    result.fold(
      (failure) => emit(RecurringTransactionError(message: failure.message)),
      (recurringTransaction) {
        final message = recurringTransaction.isActive
            ? 'Recurring transaction activated'
            : 'Recurring transaction paused';
        emit(RecurringTransactionActionSuccess(message: message));

        // Reload
        add(LoadRecurringTransactions(userId: recurringTransaction.userId));
      },
    );
  }
}
