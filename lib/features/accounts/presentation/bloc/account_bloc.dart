import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_account.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/get_account_by_id.dart';
import '../../domain/usecases/get_accounts.dart';
import '../../domain/usecases/update_account.dart';
import 'account_event.dart';
import 'account_state.dart';

/// BLoC for managing account-related business logic and state
///
/// Handles all account operations including CRUD operations and balance queries.
/// Coordinates between UI events and domain use cases.
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAccounts getAccounts;
  final GetAccountById getAccountById;
  final CreateAccount createAccount;
  final UpdateAccount updateAccount;
  final DeleteAccount deleteAccount;

  AccountBloc({
    required this.getAccounts,
    required this.getAccountById,
    required this.createAccount,
    required this.updateAccount,
    required this.deleteAccount,
  }) : super(const AccountInitial()) {
    on<LoadAccounts>(_onLoadAccounts);
    on<LoadAccountById>(_onLoadAccountById);
    on<CreateAccountRequested>(_onCreateAccountRequested);
    on<UpdateAccountRequested>(_onUpdateAccountRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<GetTotalBalanceRequested>(_onGetTotalBalanceRequested);
  }

  /// Handles loading all accounts for a user
  Future<void> _onLoadAccounts(
    LoadAccounts event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());

    final result = await getAccounts(
      GetAccountsParams(
        userId: event.userId,
        activeOnly: event.activeOnly,
      ),
    );

    result.fold(
      (failure) => emit(AccountError(message: failure.message)),
      (accounts) => emit(AccountsLoaded(
        accounts: accounts,
        activeOnly: event.activeOnly,
      )),
    );
  }

  /// Handles loading a single account by ID
  Future<void> _onLoadAccountById(
    LoadAccountById event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());

    final result = await getAccountById(
      GetAccountByIdParams(accountId: event.accountId),
    );

    result.fold(
      (failure) => emit(AccountError(message: failure.message)),
      (account) => emit(AccountLoaded(account: account)),
    );
  }

  /// Handles creating a new account
  Future<void> _onCreateAccountRequested(
    CreateAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());

    final result = await createAccount(
      CreateAccountParams(
        userId: event.userId,
        name: event.name,
        type: event.type,
        initialBalance: event.initialBalance,
        currency: event.currency,
        icon: event.icon,
        color: event.color,
        notes: event.notes,
        creditLimit: event.creditLimit,
        interestRate: event.interestRate,
      ),
    );

    result.fold(
      (failure) => emit(AccountError(message: failure.message)),
      (account) => emit(AccountActionSuccess(
        message: 'Account "${account.name}" created successfully',
        account: account,
      )),
    );
  }

  /// Handles updating an existing account
  Future<void> _onUpdateAccountRequested(
    UpdateAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());

    final result = await updateAccount(
      UpdateAccountParams(
        accountId: event.accountId,
        name: event.name,
        type: event.type,
        currency: event.currency,
        icon: event.icon,
        color: event.color,
        isActive: event.isActive,
        notes: event.notes,
        creditLimit: event.creditLimit,
        interestRate: event.interestRate,
      ),
    );

    result.fold(
      (failure) => emit(AccountError(message: failure.message)),
      (account) => emit(AccountActionSuccess(
        message: 'Account "${account.name}" updated successfully',
        account: account,
      )),
    );
  }

  /// Handles deleting an account
  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());

    final result = await deleteAccount(
      DeleteAccountParams(accountId: event.accountId),
    );

    result.fold(
      (failure) => emit(AccountError(message: failure.message)),
      (_) => emit(const AccountActionSuccess(
        message: 'Account deleted successfully',
      )),
    );
  }

  /// Handles getting total balance across accounts
  Future<void> _onGetTotalBalanceRequested(
    GetTotalBalanceRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());

    final result = await getAccounts(
      GetAccountsParams(
        userId: event.userId,
        activeOnly: event.activeOnly,
      ),
    );

    result.fold(
      (failure) => emit(AccountError(message: failure.message)),
      (accounts) {
        // Calculate total balance for the specified currency
        final totalBalance = accounts
            .where((account) => account.currency == event.currency)
            .fold(0.0, (sum, account) => sum + account.balance);

        emit(TotalBalanceLoaded(
          totalBalance: totalBalance,
          currency: event.currency,
          activeOnly: event.activeOnly,
        ));
      },
    );
  }
}
