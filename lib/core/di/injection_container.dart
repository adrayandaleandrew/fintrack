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

  // Data Sources
  // sl.registerLazySingleton<AccountRemoteDataSource>(
  //   () => AccountRemoteDataSourceMock(),
  // );

  // sl.registerLazySingleton<AccountLocalDataSource>(
  //   () => AccountLocalDataSourceImpl(database: sl()),
  // );

  // Repositories
  // sl.registerLazySingleton<AccountRepository>(
  //   () => AccountRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //     networkInfo: sl(),
  //   ),
  // );

  // Use Cases
  // sl.registerLazySingleton(() => GetAccounts(repository: sl()));
  // sl.registerLazySingleton(() => GetAccountById(repository: sl()));
  // sl.registerLazySingleton(() => CreateAccount(repository: sl()));
  // sl.registerLazySingleton(() => UpdateAccount(repository: sl()));
  // sl.registerLazySingleton(() => DeleteAccount(repository: sl()));

  // BLoC
  // sl.registerFactory(
  //   () => AccountBloc(
  //     getAccounts: sl(),
  //     getAccountById: sl(),
  //     createAccount: sl(),
  //     updateAccount: sl(),
  //     deleteAccount: sl(),
  //   ),
  // );

  // ==================== Categories Feature ====================

  // Data Sources
  // sl.registerLazySingleton<CategoryRemoteDataSource>(
  //   () => CategoryRemoteDataSourceMock(),
  // );

  // sl.registerLazySingleton<CategoryLocalDataSource>(
  //   () => CategoryLocalDataSourceImpl(database: sl()),
  // );

  // Repositories
  // sl.registerLazySingleton<CategoryRepository>(
  //   () => CategoryRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //     networkInfo: sl(),
  //   ),
  // );

  // Use Cases
  // sl.registerLazySingleton(() => GetCategories(repository: sl()));
  // sl.registerLazySingleton(() => GetCategoryById(repository: sl()));
  // sl.registerLazySingleton(() => CreateCategory(repository: sl()));
  // sl.registerLazySingleton(() => UpdateCategory(repository: sl()));
  // sl.registerLazySingleton(() => DeleteCategory(repository: sl()));
  // sl.registerLazySingleton(() => GetDefaultCategories(repository: sl()));

  // BLoC
  // sl.registerFactory(
  //   () => CategoryBloc(
  //     getCategories: sl(),
  //     getCategoryById: sl(),
  //     createCategory: sl(),
  //     updateCategory: sl(),
  //     deleteCategory: sl(),
  //     getDefaultCategories: sl(),
  //   ),
  // );

  // ==================== Transactions Feature ====================

  // Data Sources
  // sl.registerLazySingleton<TransactionRemoteDataSource>(
  //   () => TransactionRemoteDataSourceMock(),
  // );

  // sl.registerLazySingleton<TransactionLocalDataSource>(
  //   () => TransactionLocalDataSourceImpl(database: sl()),
  // );

  // Repositories
  // sl.registerLazySingleton<TransactionRepository>(
  //   () => TransactionRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //     networkInfo: sl(),
  //   ),
  // );

  // Use Cases
  // sl.registerLazySingleton(() => GetTransactions(repository: sl()));
  // sl.registerLazySingleton(() => GetTransactionById(repository: sl()));
  // sl.registerLazySingleton(() => CreateTransaction(repository: sl()));
  // sl.registerLazySingleton(() => UpdateTransaction(repository: sl()));
  // sl.registerLazySingleton(() => DeleteTransaction(repository: sl()));
  // sl.registerLazySingleton(() => FilterTransactions(repository: sl()));
  // sl.registerLazySingleton(() => SearchTransactions(repository: sl()));

  // BLoC
  // sl.registerFactory(
  //   () => TransactionBloc(
  //     getTransactions: sl(),
  //     getTransactionById: sl(),
  //     createTransaction: sl(),
  //     updateTransaction: sl(),
  //     deleteTransaction: sl(),
  //     filterTransactions: sl(),
  //     searchTransactions: sl(),
  //   ),
  // );

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
  // sl.registerLazySingleton<RecurringTransactionRemoteDataSource>(
  //   () => RecurringTransactionRemoteDataSourceMock(),
  // );

  // sl.registerLazySingleton<RecurringTransactionLocalDataSource>(
  //   () => RecurringTransactionLocalDataSourceImpl(database: sl()),
  // );

  // Repositories
  // sl.registerLazySingleton<RecurringTransactionRepository>(
  //   () => RecurringTransactionRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //     networkInfo: sl(),
  //   ),
  // );

  // Use Cases
  // sl.registerLazySingleton(() => GetRecurringTransactions(repository: sl()));
  // sl.registerLazySingleton(() => CreateRecurringTransaction(repository: sl()));
  // sl.registerLazySingleton(() => UpdateRecurringTransaction(repository: sl()));
  // sl.registerLazySingleton(() => DeleteRecurringTransaction(repository: sl()));
  // sl.registerLazySingleton(() => ProcessRecurringTransactions(repository: sl()));

  // BLoC
  // sl.registerFactory(
  //   () => RecurringTransactionBloc(
  //     getRecurringTransactions: sl(),
  //     createRecurringTransaction: sl(),
  //     updateRecurringTransaction: sl(),
  //     deleteRecurringTransaction: sl(),
  //     processRecurringTransactions: sl(),
  //   ),
  // );

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
  // sl.registerLazySingleton(() => GetDashboardSummary(
  //   accountRepository: sl(),
  //   transactionRepository: sl(),
  //   budgetRepository: sl(),
  // ));

  // BLoC
  // sl.registerFactory(
  //   () => DashboardBloc(
  //     getDashboardSummary: sl(),
  //   ),
  // );
}

/// Resets all registered dependencies
///
/// Used primarily for testing to ensure clean state between tests.
/// Can also be used when user logs out to clear cached data.
Future<void> resetDependencies() async {
  await sl.reset();
}
