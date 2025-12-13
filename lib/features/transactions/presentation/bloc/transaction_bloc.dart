import 'package:bloc/bloc.dart';
import '../../domain/usecases/create_transaction.dart' as create_usecase;
import '../../domain/usecases/delete_transaction.dart' as delete_usecase;
import '../../domain/usecases/filter_transactions.dart' as filter_usecase;
import '../../domain/usecases/get_transaction_by_id.dart' as get_by_id_usecase;
import '../../domain/usecases/get_transactions.dart' as get_usecase;
import '../../domain/usecases/search_transactions.dart' as search_usecase;
import '../../domain/usecases/update_transaction.dart' as update_usecase;
import 'transaction_event.dart';
import 'transaction_state.dart';

/// BLoC for managing transaction state
///
/// Handles all transaction-related events and emits appropriate states.
/// Coordinates between UI and use cases.
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final get_usecase.GetTransactions getTransactions;
  final get_by_id_usecase.GetTransactionById getTransactionById;
  final create_usecase.CreateTransaction createTransaction;
  final update_usecase.UpdateTransaction updateTransaction;
  final delete_usecase.DeleteTransaction deleteTransaction;
  final filter_usecase.FilterTransactions filterTransactions;
  final search_usecase.SearchTransactions searchTransactions;

  TransactionBloc({
    required this.getTransactions,
    required this.getTransactionById,
    required this.createTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.filterTransactions,
    required this.searchTransactions,
  }) : super(const TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<LoadTransactionById>(_onLoadTransactionById);
    on<CreateTransaction>(_onCreateTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<FilterTransactions>(_onFilterTransactions);
    on<SearchTransactions>(_onSearchTransactions);
  }

  /// Handle LoadTransactions event
  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final result = await getTransactions(
      get_usecase.GetTransactionsParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transactions) => emit(TransactionsLoaded(transactions: transactions)),
    );
  }

  /// Handle LoadTransactionById event
  Future<void> _onLoadTransactionById(
    LoadTransactionById event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final result = await getTransactionById(
      get_by_id_usecase.GetTransactionByIdParams(id: event.transactionId),
    );

    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transaction) => emit(TransactionLoaded(transaction: transaction)),
    );
  }

  /// Handle CreateTransaction event
  Future<void> _onCreateTransaction(
    CreateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionActionInProgress());

    final result = await createTransaction(
      create_usecase.CreateTransactionParams(transaction: event.transaction),
    );

    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transaction) => emit(
        TransactionActionSuccess(
          message: 'Transaction created successfully',
          transaction: transaction,
        ),
      ),
    );
  }

  /// Handle UpdateTransaction event
  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionActionInProgress());

    final result = await updateTransaction(
      update_usecase.UpdateTransactionParams(transaction: event.transaction),
    );

    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transaction) => emit(
        TransactionActionSuccess(
          message: 'Transaction updated successfully',
          transaction: transaction,
        ),
      ),
    );
  }

  /// Handle DeleteTransaction event
  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionActionInProgress());

    final result = await deleteTransaction(
      delete_usecase.DeleteTransactionParams(id: event.transactionId),
    );

    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (_) => emit(
        const TransactionActionSuccess(
          message: 'Transaction deleted successfully',
        ),
      ),
    );
  }

  /// Handle FilterTransactions event
  Future<void> _onFilterTransactions(
    FilterTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final result = await filterTransactions(
      filter_usecase.FilterTransactionsParams(
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
        accountId: event.accountId,
        categoryId: event.categoryId,
        type: event.type,
      ),
    );

    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transactions) => emit(TransactionsLoaded(transactions: transactions)),
    );
  }

  /// Handle SearchTransactions event
  Future<void> _onSearchTransactions(
    SearchTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final result = await searchTransactions(
      search_usecase.SearchTransactionsParams(
        userId: event.userId,
        query: event.query,
      ),
    );

    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transactions) => emit(TransactionsLoaded(transactions: transactions)),
    );
  }
}
