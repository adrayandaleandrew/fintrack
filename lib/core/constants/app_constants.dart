/// Application-wide constants.
///
/// Contains configuration values, limits, and other constants used throughout the app.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// App Information
  static const String appName = 'Finance Tracker';
  static const String appVersion = '1.0.0';

  /// Date & Time Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';
  static const String timeFormat = 'hh:mm a';
  static const String isoDateFormat = 'yyyy-MM-dd';

  /// Currency Configuration
  static const String defaultCurrency = 'USD';
  static const int defaultDecimalPlaces = 2;
  static const double minTransactionAmount = 0.01;
  static const double maxTransactionAmount = 999999999.99;

  /// Validation Limits
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxEmailLength = 255;
  static const int maxAccountNameLength = 50;
  static const int maxCategoryNameLength = 30;
  static const int maxDescriptionLength = 200;
  static const int maxNotesLength = 1000;

  /// Budget Configuration
  static const double defaultBudgetThreshold = 0.8; // 80%
  static const double minBudgetThreshold = 0.5; // 50%
  static const double maxBudgetThreshold = 1.0; // 100%
  static const double budgetAlertThreshold = 0.9; // 90%

  /// Pagination
  static const int defaultPageSize = 20;
  static const int transactionsPerPage = 20;
  static const int maxSearchResults = 50;

  /// Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 1);
  static const Duration tokenExpiration = Duration(days: 30);
  static const String cacheVersion = '1.0';

  /// Network Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
  static const int maxRetryAttempts = 3;

  /// Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String themeKey = 'theme_mode';
  static const String baseCurrencyKey = 'base_currency';
  static const String onboardingCompletedKey = 'onboarding_completed';

  /// Hive Box Names
  static const String usersBox = 'users';
  static const String accountsBox = 'accounts';
  static const String transactionsBox = 'transactions';
  static const String categoriesBox = 'categories';
  static const String budgetsBox = 'budgets';
  static const String recurringTransactionsBox = 'recurring_transactions';
  static const String currenciesBox = 'currencies';

  /// Transaction Types
  static const String transactionTypeIncome = 'income';
  static const String transactionTypeExpense = 'expense';
  static const String transactionTypeTransfer = 'transfer';

  /// Account Types
  static const String accountTypeBank = 'bank';
  static const String accountTypeCash = 'cash';
  static const String accountTypeCreditCard = 'credit_card';
  static const String accountTypeInvestment = 'investment';

  /// Budget Periods
  static const String budgetPeriodDaily = 'daily';
  static const String budgetPeriodWeekly = 'weekly';
  static const String budgetPeriodMonthly = 'monthly';
  static const String budgetPeriodYearly = 'yearly';

  /// Recurrence Frequencies
  static const String recurrenceDaily = 'daily';
  static const String recurrenceWeekly = 'weekly';
  static const String recurrenceMonthly = 'monthly';
  static const String recurrenceYearly = 'yearly';

  /// Default Category Icons (FontAwesome icon names)
  static const String defaultIncomeIcon = 'money-bill-wave';
  static const String defaultExpenseIcon = 'shopping-cart';
  static const String defaultCategoryIcon = 'tag';

  /// Default Colors (hex strings)
  static const String defaultIncomeColor = '#4CAF50'; // Green
  static const String defaultExpenseColor = '#F44336'; // Red
  static const String defaultTransferColor = '#2196F3'; // Blue
  static const String defaultCategoryColor = '#9E9E9E'; // Grey

  /// Report Types
  static const String reportExpenseByCategory = 'expense_by_category';
  static const String reportIncomeVsExpense = 'income_vs_expense';
  static const String reportMonthlyComparison = 'monthly_comparison';
  static const String reportAccountBalances = 'account_balances';

  /// Chart Configuration
  static const int maxChartDataPoints = 12; // For monthly charts
  static const int maxPieChartSlices = 8; // Show top 8, group rest as "Other"

  /// Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  /// Error Messages
  static const String genericErrorMessage =
      'An error occurred. Please try again.';
  static const String networkErrorMessage =
      'No internet connection. Please check your connection and try again.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String authErrorMessage =
      'Authentication failed. Please log in again.';
  static const String validationErrorMessage = 'Please check your input.';

  /// Success Messages
  static const String transactionCreatedMessage =
      'Transaction created successfully';
  static const String transactionUpdatedMessage =
      'Transaction updated successfully';
  static const String transactionDeletedMessage =
      'Transaction deleted successfully';
  static const String accountCreatedMessage = 'Account created successfully';
  static const String accountUpdatedMessage = 'Account updated successfully';
  static const String accountDeletedMessage = 'Account deleted successfully';
  static const String budgetCreatedMessage = 'Budget created successfully';
  static const String budgetUpdatedMessage = 'Budget updated successfully';
  static const String budgetDeletedMessage = 'Budget deleted successfully';

  /// Supported Currencies (ISO codes)
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CNY',
    'INR',
    'AUD',
    'CAD',
    'CHF',
    'BRL',
    'MXN',
    'ZAR',
    'SGD',
    'HKD',
    'SEK',
    'NOK',
    'DKK',
    'KRW',
    'RUB',
    'TRY',
  ];

  /// Default Categories (will be seeded on first app launch)
  static const List<Map<String, String>> defaultIncomeCategories = [
    {'name': 'Salary', 'icon': 'briefcase', 'color': '#4CAF50'},
    {'name': 'Freelance', 'icon': 'laptop', 'color': '#8BC34A'},
    {'name': 'Investments', 'icon': 'chart-line', 'color': '#CDDC39'},
    {'name': 'Gifts', 'icon': 'gift', 'color': '#FFC107'},
    {'name': 'Other Income', 'icon': 'plus-circle', 'color': '#4CAF50'},
  ];

  static const List<Map<String, String>> defaultExpenseCategories = [
    {'name': 'Food & Dining', 'icon': 'utensils', 'color': '#F44336'},
    {'name': 'Transportation', 'icon': 'car', 'color': '#E91E63'},
    {'name': 'Shopping', 'icon': 'shopping-bag', 'color': '#9C27B0'},
    {'name': 'Entertainment', 'icon': 'film', 'color': '#673AB7'},
    {'name': 'Bills & Utilities', 'icon': 'file-invoice', 'color': '#3F51B5'},
    {'name': 'Healthcare', 'icon': 'heartbeat', 'color': '#2196F3'},
    {'name': 'Education', 'icon': 'graduation-cap', 'color': '#00BCD4'},
    {'name': 'Travel', 'icon': 'plane', 'color': '#009688'},
    {'name': 'Personal Care', 'icon': 'user', 'color': '#4CAF50'},
    {'name': 'Groceries', 'icon': 'shopping-cart', 'color': '#8BC34A'},
    {'name': 'Insurance', 'icon': 'shield-alt', 'color': '#CDDC39'},
    {'name': 'Subscriptions', 'icon': 'sync', 'color': '#FFC107'},
    {'name': 'Home Maintenance', 'icon': 'home', 'color': '#FF9800'},
    {'name': 'Pets', 'icon': 'paw', 'color': '#FF5722'},
    {'name': 'Other Expenses', 'icon': 'minus-circle', 'color': '#F44336'},
  ];
}
