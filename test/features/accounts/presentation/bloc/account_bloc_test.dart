import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/accounts/domain/entities/account.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/create_account.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/delete_account.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/get_account_by_id.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/get_accounts.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/update_account.dart';
import 'package:finance_tracker/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:finance_tracker/features/accounts/presentation/bloc/account_event.dart';
import 'package:finance_tracker/features/accounts/presentation/bloc/account_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_bloc_test.mocks.dart';

@GenerateMocks([
  GetAccounts,
  GetAccountById,
  CreateAccount,
  UpdateAccount,
  DeleteAccount,
])
void main() {
  late AccountBloc bloc;
  late MockGetAccounts mockGetAccounts;
  late MockGetAccountById mockGetAccountById;
  late MockCreateAccount mockCreateAccount;
  late MockUpdateAccount mockUpdateAccount;
  late MockDeleteAccount mockDeleteAccount;

  setUp(() {
    mockGetAccounts = MockGetAccounts();
    mockGetAccountById = MockGetAccountById();
    mockCreateAccount = MockCreateAccount();
    mockUpdateAccount = MockUpdateAccount();
    mockDeleteAccount = MockDeleteAccount();

    bloc = AccountBloc(
      getAccounts: mockGetAccounts,
      getAccountById: mockGetAccountById,
      createAccount: mockCreateAccount,
      updateAccount: mockUpdateAccount,
      deleteAccount: mockDeleteAccount,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tUserId = 'user_1';
  final tAccounts = [
    Account(
      id: 'acc_1',
      userId: tUserId,
      name: 'Checking',
      type: AccountType.bank,
      balance: 1000.0,
      currency: 'USD',
      icon: 'account_balance',
      color: '#2196F3',
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
    Account(
      id: 'acc_2',
      userId: tUserId,
      name: 'Savings',
      type: AccountType.bank,
      balance: 5000.0,
      currency: 'USD',
      icon: 'savings',
      color: '#4CAF50',
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
  ];

  final tAccount = tAccounts.first;

  group('AccountBloc', () {
    test('initial state should be AccountInitial', () {
      expect(bloc.state, equals(const AccountInitial()));
    });

    group('LoadAccounts', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountsLoaded] when LoadAccounts succeeds',
        build: () {
          when(mockGetAccounts(any))
              .thenAnswer((_) async => Right(tAccounts));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAccounts(userId: tUserId)),
        expect: () => [
          const AccountLoading(),
          AccountsLoaded(accounts: tAccounts, activeOnly: false),
        ],
        verify: (_) {
          verify(mockGetAccounts(const GetAccountsParams(
            userId: tUserId,
            activeOnly: false,
          ))).called(1);
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountsLoaded] with activeOnly true',
        build: () {
          when(mockGetAccounts(any))
              .thenAnswer((_) async => Right(tAccounts));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAccounts(
          userId: tUserId,
          activeOnly: true,
        )),
        expect: () => [
          const AccountLoading(),
          AccountsLoaded(accounts: tAccounts, activeOnly: true),
        ],
        verify: (_) {
          verify(mockGetAccounts(const GetAccountsParams(
            userId: tUserId,
            activeOnly: true,
          ))).called(1);
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when LoadAccounts fails',
        build: () {
          when(mockGetAccounts(any))
              .thenAnswer((_) async => Left(ServerFailure('Server error')));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAccounts(userId: tUserId)),
        expect: () => [
          const AccountLoading(),
          const AccountError(message: 'Server error'),
        ],
      );
    });

    group('LoadAccountById', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountLoaded] when LoadAccountById succeeds',
        build: () {
          when(mockGetAccountById(any))
              .thenAnswer((_) async => Right(tAccount));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAccountById(accountId: 'acc_1')),
        expect: () => [
          const AccountLoading(),
          AccountLoaded(account: tAccount),
        ],
        verify: (_) {
          verify(mockGetAccountById(
            const GetAccountByIdParams(accountId: 'acc_1'),
          )).called(1);
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when LoadAccountById fails',
        build: () {
          when(mockGetAccountById(any))
              .thenAnswer((_) async => Left(NotFoundFailure('Account not found')));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAccountById(accountId: 'acc_1')),
        expect: () => [
          const AccountLoading(),
          const AccountError(message: 'Account not found'),
        ],
      );
    });

    group('CreateAccountRequested', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountActionSuccess] when CreateAccount succeeds',
        build: () {
          when(mockCreateAccount(any))
              .thenAnswer((_) async => Right(tAccount));
          return bloc;
        },
        act: (bloc) => bloc.add(const CreateAccountRequested(
          userId: tUserId,
          name: 'Checking',
          type: AccountType.bank,
          initialBalance: 1000.0,
          currency: 'USD',
        )),
        expect: () => [
          const AccountLoading(),
          AccountActionSuccess(
            message: 'Account "Checking" created successfully',
            account: tAccount,
          ),
        ],
        verify: (_) {
          verify(mockCreateAccount(any)).called(1);
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when CreateAccount fails',
        build: () {
          when(mockCreateAccount(any))
              .thenAnswer((_) async => Left(ValidationFailure('Name is required')));
          return bloc;
        },
        act: (bloc) => bloc.add(const CreateAccountRequested(
          userId: tUserId,
          name: '',
          type: AccountType.bank,
          initialBalance: 0,
          currency: 'USD',
        )),
        expect: () => [
          const AccountLoading(),
          const AccountError(message: 'Name is required'),
        ],
      );
    });

    group('UpdateAccountRequested', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountActionSuccess] when UpdateAccount succeeds',
        build: () {
          when(mockUpdateAccount(any))
              .thenAnswer((_) async => Right(tAccount));
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateAccountRequested(
          accountId: 'acc_1',
          name: 'Checking',
        )),
        expect: () => [
          const AccountLoading(),
          AccountActionSuccess(
            message: 'Account "Checking" updated successfully',
            account: tAccount,
          ),
        ],
        verify: (_) {
          verify(mockUpdateAccount(any)).called(1);
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when UpdateAccount fails',
        build: () {
          when(mockUpdateAccount(any))
              .thenAnswer((_) async => Left(NotFoundFailure('Account not found')));
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateAccountRequested(
          accountId: 'invalid_id',
          name: 'Test',
        )),
        expect: () => [
          const AccountLoading(),
          const AccountError(message: 'Account not found'),
        ],
      );
    });

    group('DeleteAccountRequested', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountActionSuccess] when DeleteAccount succeeds',
        build: () {
          when(mockDeleteAccount(any))
              .thenAnswer((_) async => const Right(null));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteAccountRequested(accountId: 'acc_1')),
        expect: () => [
          const AccountLoading(),
          const AccountActionSuccess(message: 'Account deleted successfully'),
        ],
        verify: (_) {
          verify(mockDeleteAccount(
            const DeleteAccountParams(accountId: 'acc_1'),
          )).called(1);
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when DeleteAccount fails',
        build: () {
          when(mockDeleteAccount(any)).thenAnswer(
            (_) async => Left(ValidationFailure('Cannot delete account with transactions')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteAccountRequested(accountId: 'acc_1')),
        expect: () => [
          const AccountLoading(),
          const AccountError(message: 'Cannot delete account with transactions'),
        ],
      );
    });

    group('GetTotalBalanceRequested', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, TotalBalanceLoaded] when GetTotalBalance succeeds',
        build: () {
          when(mockGetAccounts(any))
              .thenAnswer((_) async => Right(tAccounts));
          return bloc;
        },
        act: (bloc) => bloc.add(const GetTotalBalanceRequested(
          userId: tUserId,
          currency: 'USD',
        )),
        expect: () => [
          const AccountLoading(),
          const TotalBalanceLoaded(
            totalBalance: 6000.0, // 1000 + 5000
            currency: 'USD',
            activeOnly: true,
          ),
        ],
        verify: (_) {
          verify(mockGetAccounts(const GetAccountsParams(
            userId: tUserId,
            activeOnly: true,
          ))).called(1);
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when GetTotalBalance fails',
        build: () {
          when(mockGetAccounts(any))
              .thenAnswer((_) async => Left(ServerFailure('Server error')));
          return bloc;
        },
        act: (bloc) => bloc.add(const GetTotalBalanceRequested(
          userId: tUserId,
          currency: 'USD',
        )),
        expect: () => [
          const AccountLoading(),
          const AccountError(message: 'Server error'),
        ],
      );
    });
  });
}
