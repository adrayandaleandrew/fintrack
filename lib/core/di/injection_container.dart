import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Authentication
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource_impl.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_mock.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/is_user_logged_in.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/register.dart';
import '../../features/auth/domain/usecases/send_password_reset_email.dart';
import '../../features/auth/domain/usecases/update_profile.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Accounts - TODO: Implement in Phase 2
// import '../../features/accounts/data/datasources/account_local_datasource.dart';
// import '../../features/accounts/data/datasources/account_local_datasource_impl.dart';
// import '../../features/accounts/data/datasources/account_remote_datasource.dart';
// import '../../features/accounts/data/datasources/account_remote_datasource_mock.dart';
// import '../../features/accounts/data/repositories/account_repository_impl.dart';
// import '../../features/accounts/domain/repositories/account_repository.dart';
// import '../../features/accounts/domain/usecases/create_account.dart';
// import '../../features/accounts/domain/usecases/delete_account.dart';
// import '../../features/accounts/domain/usecases/get_account_by_id.dart';
// import '../../features/accounts/domain/usecases/get_accounts.dart';
// import '../../features/accounts/domain/usecases/update_account.dart';
// import '../../features/accounts/presentation/bloc/account_bloc.dart';

// Categories
import '../../features/categories/data/datasources/category_local_datasource.dart';
import '../../features/categories/data/datasources/category_local_datasource_impl.dart';
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/categories/data/datasources/category_remote_datasource_mock.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/create_category.dart';
import '../../features/categories/domain/usecases/delete_category.dart';
import '../../features/categories/domain/usecases/get_categories.dart';
import '../../features/categories/domain/usecases/get_category_by_id.dart';
import '../../features/categories/domain/usecases/get_default_categories.dart';
import '../../features/categories/domain/usecases/initialize_default_categories.dart';
import '../../features/categories/domain/usecases/update_category.dart';
import '../../features/categories/presentation/bloc/category_bloc.dart';
// Accounts
import '../../features/accounts/data/datasources/account_local_datasource.dart';
import '../../features/accounts/data/datasources/account_local_datasource_impl.dart';
import '../../features/accounts/data/datasources/account_remote_datasource.dart';
import '../../features/accounts/data/datasources/account_remote_datasource_mock.dart';
import '../../features/accounts/data/repositories/account_repository_impl.dart';
import '../../features/accounts/domain/repositories/account_repository.dart';
import '../../features/accounts/domain/usecases/create_account.dart';
import '../../features/accounts/domain/usecases/delete_account.dart';
import '../../features/accounts/domain/usecases/get_account_by_id.dart';
import '../../features/accounts/domain/usecases/get_accounts.dart';
import '../../features/accounts/domain/usecases/update_account.dart';
import '../../features/accounts/presentation/bloc/account_bloc.dart';

// Transactions
import '../../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../../features/transactions/data/datasources/transaction_local_datasource_impl.dart';
import '../../features/transactions/data/datasources/transaction_remote_datasource.dart';
import '../../features/transactions/data/datasources/transaction_remote_datasource_mock.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/create_transaction.dart';
import '../../features/transactions/domain/usecases/delete_transaction.dart';
import '../../features/transactions/domain/usecases/filter_transactions.dart';
import '../../features/transactions/domain/usecases/get_transaction_by_id.dart';
import '../../features/transactions/domain/usecases/get_transactions.dart';
import '../../features/transactions/domain/usecases/search_transactions.dart';
import '../../features/transactions/domain/usecases/update_transaction.dart';
import '../../features/transactions/presentation/bloc/transaction_bloc.dart';

// Dashboard
import '../../features/dashboard/domain/usecases/get_dashboard_summary.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Budgets
import '../../features/budgets/data/datasources/budget_remote_datasource.dart';
import '../../features/budgets/data/datasources/budget_remote_datasource_mock.dart';
import '../../features/budgets/data/repositories/budget_repository_impl.dart';
import '../../features/budgets/domain/repositories/budget_repository.dart';
import '../../features/budgets/domain/usecases/get_budgets.dart';
import '../../features/budgets/domain/usecases/create_budget.dart';
import '../../features/budgets/domain/usecases/update_budget.dart';
import '../../features/budgets/domain/usecases/delete_budget.dart';
import '../../features/budgets/domain/usecases/calculate_budget_usage.dart';
import '../../features/budgets/presentation/bloc/budget_bloc.dart';

// Recurring Transactions
import '../../features/recurring_transactions/data/datasources/recurring_transaction_remote_datasource.dart';
import '../../features/recurring_transactions/data/datasources/recurring_transaction_remote_datasource_mock.dart';
import '../../features/recurring_transactions/data/repositories/recurring_transaction_repository_impl.dart';
import '../../features/recurring_transactions/domain/repositories/recurring_transaction_repository.dart';
import '../../features/recurring_transactions/domain/usecases/get_recurring_transactions.dart';
import '../../features/recurring_transactions/domain/usecases/create_recurring_transaction.dart';
import '../../features/recurring_transactions/domain/usecases/update_recurring_transaction.dart';
import '../../features/recurring_transactions/domain/usecases/delete_recurring_transaction.dart';
import '../../features/recurring_transactions/domain/usecases/process_due_recurring_transactions.dart';
import '../../features/recurring_transactions/presentation/bloc/recurring_transaction_bloc.dart';

// Reports
import '../../features/reports/data/repositories/reports_repository_impl.dart';
import '../../features/reports/domain/repositories/reports_repository.dart';
import '../../features/reports/domain/usecases/get_expense_breakdown.dart';
import '../../features/reports/domain/usecases/get_financial_trends.dart';
import '../../features/reports/domain/usecases/get_monthly_comparison.dart';
import '../../features/reports/presentation/bloc/reports_bloc.dart';

// Currency
import '../../features/currency/data/datasources/currency_local_datasource.dart';
import '../../features/currency/data/datasources/currency_local_datasource_impl.dart';
import '../../features/currency/data/datasources/currency_remote_datasource.dart';
import '../../features/currency/data/datasources/currency_remote_datasource_mock.dart';
import '../../features/currency/data/repositories/currency_repository_impl.dart';
import '../../features/currency/domain/repositories/currency_repository.dart';
import '../../features/currency/domain/usecases/convert_currency.dart';
import '../../features/currency/domain/usecases/get_base_currency.dart';
import '../../features/currency/domain/usecases/get_currencies.dart';
import '../../features/currency/domain/usecases/get_exchange_rates.dart';
import '../../features/currency/domain/usecases/update_base_currency.dart';
import '../../features/currency/presentation/bloc/currency_bloc.dart';

/// Service locator instance
///
/// This is the single global instance of GetIt used throughout the app
/// for dependency injection. All dependencies are registered here.
final sl = GetIt.instance;

/// Initializes all app dependencies
///
/// This function must be called before runApp() in main.dart.
/// It registers all dependencies in the service locator following this order:
/// 1. External dependencies (3rd party packages)
/// 2. Core utilities
/// 3. Data sources
/// 4. Repositories
/// 5. Use cases
/// 6. BLoCs
Future<void> initializeDependencies() async {
  // ==================== External Dependencies ====================

  // Shared Preferences - for simple key-value storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Secure Storage - for sensitive data (tokens, credentials)
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  // Hive - NoSQL database for local storage
  await Hive.initFlutter();
  sl.registerLazySingleton<HiveInterface>(() => Hive);

  // Dio - HTTP client for API calls
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptors for logging, authentication, error handling
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: false,
    ),
  );

  sl.registerLazySingleton<Dio>(() => dio);

  // Connectivity - for network status monitoring
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // ==================== Core Dependencies ====================

  // Network Info - checks network connectivity
  // sl.registerLazySingleton<NetworkInfo>(
  //   () => NetworkInfoImpl(connectivity: sl()),
  // );

  // Local Storage - wrapper for shared preferences
  // sl.registerLazySingleton<LocalStorage>(
  //   () => LocalStorageImpl(sharedPreferences: sl()),
  // );

  // Secure Storage - wrapper for flutter_secure_storage
  // sl.registerLazySingleton<SecureStorage>(
  //   () => SecureStorageImpl(secureStorage: sl()),
  // );

  // Database - wrapper for Hive
  // sl.registerLazySingleton<Database>(
  //   () => HiveDatabase(hive: sl()),
  // );

  // ==================== Authentication Feature ====================

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceMock(), // Mock implementation initially
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
      secureStorage: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => Login(repository: sl()));
  sl.registerLazySingleton(() => Register(repository: sl()));
  sl.registerLazySingleton(() => Logout(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUser(repository: sl()));
  sl.registerLazySingleton(() => IsUserLoggedIn(repository: sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmail(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfile(repository: sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      register: sl(),
      logout: sl(),
      getCurrentUser: sl(),
      isUserLoggedIn: sl(),
      sendPasswordResetEmail: sl(),
      updateProfile: sl(),
    ),
  );

  // ==================== Accounts Feature ====================
  // TODO: Implement in Phase 2

  // Data Sources
  // sl.registerLazySingleton<AccountRemoteDataSource>(
  //   () => AccountRemoteDataSourceMock(), // Mock implementation initially
  // );

  // sl.registerLazySingleton<AccountLocalDataSource>(
  //   () => AccountLocalDataSourceImpl(hive: sl()),
  // );

  // Repositories
  // sl.registerLazySingleton<AccountRepository>(
  //   () => AccountRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //   ),
  // );
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceMock(), // Mock implementation initially
  );

  sl.registerLazySingleton<AccountLocalDataSource>(
    () => AccountLocalDataSourceImpl(hive: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAccounts(repository: sl()));
  sl.registerLazySingleton(() => GetAccountById(repository: sl()));
  sl.registerLazySingleton(() => CreateAccount(repository: sl()));
  sl.registerLazySingleton(() => UpdateAccount(repository: sl()));
  sl.registerLazySingleton(() => DeleteAccount(repository: sl()));

  // BLoC
  sl.registerFactory(
    () => AccountBloc(
      getAccounts: sl(),
      getAccountById: sl(),
      createAccount: sl(),
      updateAccount: sl(),
      deleteAccount: sl(),
    ),
  );

  // ==================== Categories Feature ====================

  // Data Sources
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceMock(), // Mock implementation initially
  );

  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(hive: sl()),
  );

  // Repositories
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCategories(repository: sl()));
  sl.registerLazySingleton(() => GetCategoryById(repository: sl()));
  sl.registerLazySingleton(() => CreateCategory(repository: sl()));
  sl.registerLazySingleton(() => UpdateCategory(repository: sl()));
  sl.registerLazySingleton(() => DeleteCategory(repository: sl()));
  sl.registerLazySingleton(() => GetDefaultCategories(repository: sl()));
  sl.registerLazySingleton(() => InitializeDefaultCategories(repository: sl()));

  // BLoC
  sl.registerFactory(
    () => CategoryBloc(
      getCategories: sl(),
      getCategoryById: sl(),
      createCategory: sl(),
      updateCategory: sl(),
      deleteCategory: sl(),
      getDefaultCategories: sl(),
      initializeDefaultCategories: sl(),
    ),
  );

  // ==================== Transactions Feature ====================

  // Data Sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceMock(
      accountDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(hive: sl()),
  );

  // Repositories
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTransactions(repository: sl()));
  sl.registerLazySingleton(() => GetTransactionById(repository: sl()));
  sl.registerLazySingleton(() => CreateTransaction(repository: sl()));
  sl.registerLazySingleton(() => UpdateTransaction(repository: sl()));
  sl.registerLazySingleton(() => DeleteTransaction(repository: sl()));
  sl.registerLazySingleton(() => FilterTransactions(repository: sl()));
  sl.registerLazySingleton(() => SearchTransactions(repository: sl()));

  // BLoC
  sl.registerFactory(
    () => TransactionBloc(
      getTransactions: sl(),
      getTransactionById: sl(),
      createTransaction: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
      filterTransactions: sl(),
      searchTransactions: sl(),
    ),
  );

  // ==================== Budgets Feature ====================

  // Data Sources
  // sl.registerLazySingleton<BudgetRemoteDataSource>(
  //   () => BudgetRemoteDataSourceMock(),
  // );

  // sl.registerLazySingleton<BudgetLocalDataSource>(
  //   () => BudgetLocalDataSourceImpl(database: sl()),
  // );

  // Repositories
  // sl.registerLazySingleton<BudgetRepository>(
  //   () => BudgetRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //     networkInfo: sl(),
  //   ),
  // );

  // Use Cases
  // sl.registerLazySingleton(() => GetBudgets(repository: sl()));
  // sl.registerLazySingleton(() => GetBudgetById(repository: sl()));
  // sl.registerLazySingleton(() => CreateBudget(repository: sl()));
  // sl.registerLazySingleton(() => UpdateBudget(repository: sl()));
  // sl.registerLazySingleton(() => DeleteBudget(repository: sl()));
  // sl.registerLazySingleton(() => CalculateBudgetUsage(repository: sl()));

  // BLoC
  // sl.registerFactory(
  //   () => BudgetBloc(
  //     getBudgets: sl(),
  //     getBudgetById: sl(),
  //     createBudget: sl(),
  //     updateBudget: sl(),
  //     deleteBudget: sl(),
  //     calculateBudgetUsage: sl(),
  //   ),
  // );

  // ==================== Recurring Transactions Feature ====================

  // Data Sources
  sl.registerLazySingleton<RecurringTransactionRemoteDataSource>(
    () => RecurringTransactionRemoteDataSourceMock(),
  );

  // Repositories
  sl.registerLazySingleton<RecurringTransactionRepository>(
    () => RecurringTransactionRepositoryImpl(
      remoteDataSource: sl(),
      transactionRepository: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetRecurringTransactions(sl()),
  );

  sl.registerLazySingleton(
    () => CreateRecurringTransaction(sl()),
  );

  sl.registerLazySingleton(
    () => UpdateRecurringTransaction(sl()),
  );

  sl.registerLazySingleton(
    () => DeleteRecurringTransaction(sl()),
  );

  sl.registerLazySingleton(
    () => ProcessDueRecurringTransactions(sl()),
  );

  // BLoC
  sl.registerFactory(
    () => RecurringTransactionBloc(
      getRecurringTransactions: sl(),
      createRecurringTransaction: sl(),
      updateRecurringTransaction: sl(),
      deleteRecurringTransaction: sl(),
      processDueRecurringTransactions: sl(),
    ),
  );

  // ==================== Reports Feature ====================

  // Data Sources
  // sl.registerLazySingleton<ReportRemoteDataSource>(
  //   () => ReportRemoteDataSourceMock(),
  // );

  // Repositories
  // sl.registerLazySingleton<ReportRepository>(
  //   () => ReportRepositoryImpl(
  //     remoteDataSource: sl(),
  //     transactionRepository: sl(),
  //   ),
  // );

  // Use Cases
  // sl.registerLazySingleton(() => GetExpenseBreakdown(repository: sl()));
  // sl.registerLazySingleton(() => GetIncomeTrends(repository: sl()));
  // sl.registerLazySingleton(() => GetExpenseTrends(repository: sl()));
  // sl.registerLazySingleton(() => GetMonthlyComparison(repository: sl()));
  // sl.registerLazySingleton(() => ExportReport(repository: sl()));

  // BLoC
  // sl.registerFactory(
  //   () => ReportBloc(
  //     getExpenseBreakdown: sl(),
  //     getIncomeTrends: sl(),
  //     getExpenseTrends: sl(),
  //     getMonthlyComparison: sl(),
  //     exportReport: sl(),
  //   ),
  // );

  // ==================== Currency Feature ====================

  // Data Sources
  // sl.registerLazySingleton<CurrencyRemoteDataSource>(
  //   () => CurrencyRemoteDataSourceMock(),
  // );

  // sl.registerLazySingleton<CurrencyLocalDataSource>(
  //   () => CurrencyLocalDataSourceImpl(database: sl()),
  // );

  // Repositories
  // sl.registerLazySingleton<CurrencyRepository>(
  //   () => CurrencyRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //   ),
  // );

  // Use Cases
  // sl.registerLazySingleton(() => GetCurrencies(repository: sl()));
  // sl.registerLazySingleton(() => ConvertCurrency(repository: sl()));
  // sl.registerLazySingleton(() => UpdateExchangeRates(repository: sl()));

  // BLoC
  // sl.registerFactory(
  //   () => CurrencyBloc(
  //     getCurrencies: sl(),
  //     convertCurrency: sl(),
  //     updateExchangeRates: sl(),
  //   ),
  // );

  // ==================== Dashboard Feature ====================

  // Use Cases
  sl.registerLazySingleton(
    () => GetDashboardSummary(
      accountRepository: sl(),
      transactionRepository: sl(),
    ),
  );

  // BLoC
  sl.registerFactory(
    () => DashboardBloc(
      getDashboardSummary: sl(),
    ),
  );

  // ==================== Budget Feature ====================

  // Data Sources
  sl.registerLazySingleton<BudgetRemoteDataSource>(
    () => BudgetRemoteDataSourceMock(),
  );

  // Repositories
  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(
      remoteDataSource: sl(),
      transactionRepository: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetBudgets(sl()),
  );

  sl.registerLazySingleton(
    () => CreateBudget(sl()),
  );

  sl.registerLazySingleton(
    () => UpdateBudget(sl()),
  );

  sl.registerLazySingleton(
    () => DeleteBudget(sl()),
  );

  sl.registerLazySingleton(
    () => CalculateBudgetUsage(sl()),
  );

  // BLoC
  sl.registerFactory(
    () => BudgetBloc(
      getBudgets: sl(),
      createBudget: sl(),
      updateBudget: sl(),
      deleteBudget: sl(),
      calculateBudgetUsage: sl(),
    ),
  );

  // ==================== Reports Feature ====================

  // Repositories
  sl.registerLazySingleton<ReportsRepository>(
    () => ReportsRepositoryImpl(
      transactionRepository: sl(),
      categoryRepository: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetExpenseBreakdown(sl()),
  );

  sl.registerLazySingleton(
    () => GetFinancialTrends(sl()),
  );

  sl.registerLazySingleton(
    () => GetMonthlyComparison(sl()),
  );

  // BLoC
  sl.registerFactory(
    () => ReportsBloc(
      getExpenseBreakdown: sl(),
      getFinancialTrends: sl(),
      getMonthlyComparison: sl(),
    ),
  );

  // ==================== Currency Feature ====================

  // Data Sources
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceMock(),
  );

  sl.registerLazySingleton<CurrencyLocalDataSource>(
    () => CurrencyLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCurrencies(sl()));
  sl.registerLazySingleton(() => GetExchangeRates(sl()));
  sl.registerLazySingleton(() => ConvertCurrency(sl()));
  sl.registerLazySingleton(() => GetBaseCurrency(sl()));
  sl.registerLazySingleton(() => UpdateBaseCurrency(sl()));

  // BLoC
  sl.registerFactory(
    () => CurrencyBloc(
      getCurrencies: sl(),
      getExchangeRates: sl(),
      convertCurrency: sl(),
      getBaseCurrency: sl(),
      updateBaseCurrency: sl(),
    ),
  );
}

/// Resets all registered dependencies
///
/// Used primarily for testing to ensure clean state between tests.
/// Can also be used when user logs out to clear cached data.
Future<void> resetDependencies() async {
  await sl.reset();
}
