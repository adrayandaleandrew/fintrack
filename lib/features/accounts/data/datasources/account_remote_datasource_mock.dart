import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/account.dart';
import '../models/account_model.dart';
import 'account_remote_datasource.dart';

/// Mock implementation of AccountRemoteDataSource
///
/// Simulates API calls with in-memory storage.
/// Use this during development before real API is available.
class AccountRemoteDataSourceMock implements AccountRemoteDataSource {
  // In-memory storage for accounts
  final List<AccountModel> _accounts = [];
  int _nextId = 1;

  AccountRemoteDataSourceMock() {
    _initializeMockData();
  }

  /// Initializes mock data with sample accounts
  void _initializeMockData() {
    final now = DateTime.now();

    // Sample bank account
    _accounts.add(AccountModel(
      id: 'account_${_nextId++}',
      userId: 'user_1',
      name: 'Main Checking',
      type: AccountType.bank,
      balance: 5420.50,
      currency: AppConstants.defaultCurrency,
      icon: 'account_balance',
      color: '#2196F3',
      isActive: true,
      createdAt: now.subtract(const Duration(days: 90)),
      updatedAt: now,
      notes: 'Primary checking account for daily expenses',
    ));

    // Sample savings account
    _accounts.add(AccountModel(
      id: 'account_${_nextId++}',
      userId: 'user_1',
      name: 'Savings',
      type: AccountType.bank,
      balance: 12500.00,
      currency: AppConstants.defaultCurrency,
      icon: 'savings',
      color: '#4CAF50',
      isActive: true,
      createdAt: now.subtract(const Duration(days: 180)),
      updatedAt: now,
      notes: 'Emergency fund and savings',
      interestRate: 2.5,
    ));

    // Sample cash account
    _accounts.add(AccountModel(
      id: 'account_${_nextId++}',
      userId: 'user_1',
      name: 'Cash Wallet',
      type: AccountType.cash,
      balance: 250.00,
      currency: AppConstants.defaultCurrency,
      icon: 'account_balance_wallet',
      color: '#FF9800',
      isActive: true,
      createdAt: now.subtract(const Duration(days: 60)),
      updatedAt: now,
    ));

    // Sample credit card
    _accounts.add(AccountModel(
      id: 'account_${_nextId++}',
      userId: 'user_1',
      name: 'Visa Credit Card',
      type: AccountType.creditCard,
      balance: -1250.75, // Negative balance for credit cards
      currency: AppConstants.defaultCurrency,
      icon: 'credit_card',
      color: '#F44336',
      isActive: true,
      createdAt: now.subtract(const Duration(days: 120)),
      updatedAt: now,
      creditLimit: 5000.00,
      notes: 'Primary credit card for online purchases',
    ));

    // Sample investment account
    _accounts.add(AccountModel(
      id: 'account_${_nextId++}',
      userId: 'user_1',
      name: 'Investment Portfolio',
      type: AccountType.investment,
      balance: 8750.25,
      currency: AppConstants.defaultCurrency,
      icon: 'trending_up',
      color: '#9C27B0',
      isActive: true,
      createdAt: now.subtract(const Duration(days: 365)),
      updatedAt: now,
      interestRate: 7.5,
    ));
  }

  @override
  Future<List<AccountModel>> getAccounts({
    required String userId,
    bool activeOnly = false,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    var accounts = _accounts.where((account) => account.userId == userId);

    if (activeOnly) {
      accounts = accounts.where((account) => account.isActive);
    }

    return accounts.toList();
  }

  @override
  Future<AccountModel> getAccountById({
    required String accountId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _accounts.firstWhere((account) => account.id == accountId);
    } catch (e) {
      throw NotFoundException('Account not found with ID: $accountId');
    }
  }

  @override
  Future<AccountModel> createAccount({
    required String userId,
    required String name,
    required AccountType type,
    required double initialBalance,
    required String currency,
    String? icon,
    String? color,
    String? notes,
    double? creditLimit,
    double? interestRate,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Validate
    if (name.trim().isEmpty) {
      throw ValidationException('Account name cannot be empty');
    }

    if (type == AccountType.creditCard && creditLimit == null) {
      throw ValidationException('Credit limit is required for credit card accounts');
    }

    final now = DateTime.now();

    final newAccount = AccountModel(
      id: 'account_${_nextId++}',
      userId: userId,
      name: name,
      type: type,
      balance: initialBalance,
      currency: currency,
      icon: icon ?? type.defaultIcon,
      color: color ?? '#2196F3',
      isActive: true,
      createdAt: now,
      updatedAt: now,
      notes: notes,
      creditLimit: creditLimit,
      interestRate: interestRate,
    );

    _accounts.add(newAccount);
    return newAccount;
  }

  @override
  Future<AccountModel> updateAccount({
    required String accountId,
    String? name,
    AccountType? type,
    String? currency,
    String? icon,
    String? color,
    bool? isActive,
    String? notes,
    double? creditLimit,
    double? interestRate,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _accounts.indexWhere((account) => account.id == accountId);

    if (index == -1) {
      throw NotFoundException('Account not found with ID: $accountId');
    }

    final account = _accounts[index];
    final updatedAccount = account.copyWith(
      name: name ?? account.name,
      type: type ?? account.type,
      currency: currency ?? account.currency,
      icon: icon ?? account.icon,
      color: color ?? account.color,
      isActive: isActive ?? account.isActive,
      notes: notes ?? account.notes,
      creditLimit: creditLimit ?? account.creditLimit,
      interestRate: interestRate ?? account.interestRate,
      updatedAt: DateTime.now(),
    ) as AccountModel;

    _accounts[index] = updatedAccount;
    return updatedAccount;
  }

  @override
  Future<void> deleteAccount({
    required String accountId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _accounts.indexWhere((account) => account.id == accountId);

    if (index == -1) {
      throw NotFoundException('Account not found with ID: $accountId');
    }

    // In a real implementation, check if account has transactions
    // For now, we'll just delete
    _accounts.removeAt(index);
  }

  @override
  Future<AccountModel> updateBalance({
    required String accountId,
    required double newBalance,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _accounts.indexWhere((account) => account.id == accountId);

    if (index == -1) {
      throw NotFoundException('Account not found with ID: $accountId');
    }

    final account = _accounts[index];
    final updatedAccount = account.copyWith(
      balance: newBalance,
      updatedAt: DateTime.now(),
    ) as AccountModel;

    _accounts[index] = updatedAccount;
    return updatedAccount;
  }

  /// Clears all mock data (for testing)
  void clear() {
    _accounts.clear();
    _nextId = 1;
    _initializeMockData();
  }
}
