/// API endpoint constants for the finance tracker app.
///
/// Contains all API paths for both mock and real API implementations.
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();

  /// Base URL for the API
  ///
  /// For mock implementation, this is not actually used (in-memory storage).
  /// When switching to real API, update this to your backend URL.
  static const String baseUrl = 'http://localhost:3000/api/v1';

  /// API version
  static const String apiVersion = 'v1';

  // ==================== Authentication Endpoints ====================

  /// POST - User registration
  /// Body: { email: string, name: string, password: string }
  /// Returns: { user: User, token: string }
  static const String register = '/auth/register';

  /// POST - User login
  /// Body: { email: string, password: string }
  /// Returns: { user: User, token: string }
  static const String login = '/auth/login';

  /// POST - User logout
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { message: string }
  static const String logout = '/auth/logout';

  /// POST - Refresh authentication token
  /// Headers: { Authorization: "Bearer <refresh_token>" }
  /// Returns: { token: string, refreshToken: string }
  static const String refreshToken = '/auth/refresh';

  /// GET - Get current user information
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { user: User }
  static const String currentUser = '/auth/me';

  /// POST - Request password reset
  /// Body: { email: string }
  /// Returns: { message: string }
  static const String forgotPassword = '/auth/forgot-password';

  /// POST - Reset password with token
  /// Body: { token: string, newPassword: string }
  /// Returns: { message: string }
  static const String resetPassword = '/auth/reset-password';

  // ==================== Account Endpoints ====================

  /// GET - Get all accounts for current user
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { accounts: Account[] }
  static const String accounts = '/accounts';

  /// GET - Get single account by ID
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { account: Account }
  static String accountById(String id) => '/accounts/$id';

  /// POST - Create new account
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { name: string, type: string, balance: number, currency: string }
  /// Returns: { account: Account }
  static const String createAccount = '/accounts';

  /// PUT - Update account
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { name?: string, icon?: string, color?: string }
  /// Returns: { account: Account }
  static String updateAccount(String id) => '/accounts/$id';

  /// DELETE - Delete account
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { message: string }
  static String deleteAccount(String id) => '/accounts/$id';

  // ==================== Transaction Endpoints ====================

  /// GET - Get all transactions for current user
  /// Headers: { Authorization: "Bearer <token>" }
  /// Query params: ?page=1&limit=20&startDate=...&endDate=...&category=...&account=...
  /// Returns: { transactions: Transaction[], pagination: {...} }
  static const String transactions = '/transactions';

  /// GET - Get single transaction by ID
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { transaction: Transaction }
  static String transactionById(String id) => '/transactions/$id';

  /// POST - Create new transaction
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { accountId, categoryId, type, amount, currency, date, description }
  /// Returns: { transaction: Transaction }
  static const String createTransaction = '/transactions';

  /// PUT - Update transaction
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { amount?, category?, description?, date?, ... }
  /// Returns: { transaction: Transaction }
  static String updateTransaction(String id) => '/transactions/$id';

  /// DELETE - Delete transaction
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { message: string }
  static String deleteTransaction(String id) => '/transactions/$id';

  /// GET - Search transactions
  /// Headers: { Authorization: "Bearer <token>" }
  /// Query params: ?q=search_term
  /// Returns: { transactions: Transaction[] }
  static const String searchTransactions = '/transactions/search';

  // ==================== Category Endpoints ====================

  /// GET - Get all categories for current user
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { categories: Category[] }
  static const String categories = '/categories';

  /// GET - Get single category by ID
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { category: Category }
  static String categoryById(String id) => '/categories/$id';

  /// POST - Create new category
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { name: string, type: string, icon: string, color: string }
  /// Returns: { category: Category }
  static const String createCategory = '/categories';

  /// PUT - Update category
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { name?: string, icon?: string, color?: string }
  /// Returns: { category: Category }
  static String updateCategory(String id) => '/categories/$id';

  /// DELETE - Delete category
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { message: string }
  static String deleteCategory(String id) => '/categories/$id';

  // ==================== Budget Endpoints ====================

  /// GET - Get all budgets for current user
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { budgets: Budget[] }
  static const String budgets = '/budgets';

  /// GET - Get single budget by ID
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { budget: Budget }
  static String budgetById(String id) => '/budgets/$id';

  /// POST - Create new budget
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { categoryId, amount, currency, period, startDate, alertThreshold }
  /// Returns: { budget: Budget }
  static const String createBudget = '/budgets';

  /// PUT - Update budget
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { amount?, period?, alertThreshold?, ... }
  /// Returns: { budget: Budget }
  static String updateBudget(String id) => '/budgets/$id';

  /// DELETE - Delete budget
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { message: string }
  static String deleteBudget(String id) => '/budgets/$id';

  /// GET - Get budget usage/spending for a budget
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { budget: Budget, spent: number, remaining: number, percentUsed: number }
  static String budgetUsage(String id) => '/budgets/$id/usage';

  // ==================== Recurring Transaction Endpoints ====================

  /// GET - Get all recurring transactions
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { recurringTransactions: RecurringTransaction[] }
  static const String recurringTransactions = '/recurring-transactions';

  /// GET - Get single recurring transaction by ID
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { recurringTransaction: RecurringTransaction }
  static String recurringTransactionById(String id) =>
      '/recurring-transactions/$id';

  /// POST - Create new recurring transaction
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { accountId, categoryId, amount, currency, frequency, startDate }
  /// Returns: { recurringTransaction: RecurringTransaction }
  static const String createRecurringTransaction = '/recurring-transactions';

  /// PUT - Update recurring transaction
  /// Headers: { Authorization: "Bearer <token>" }
  /// Body: { amount?, frequency?, ... }
  /// Returns: { recurringTransaction: RecurringTransaction }
  static String updateRecurringTransaction(String id) =>
      '/recurring-transactions/$id';

  /// DELETE - Delete recurring transaction
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { message: string }
  static String deleteRecurringTransaction(String id) =>
      '/recurring-transactions/$id';

  /// POST - Process pending recurring transactions (admin/cron job)
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { processed: number, transactions: Transaction[] }
  static const String processRecurringTransactions =
      '/recurring-transactions/process';

  // ==================== Currency Endpoints ====================

  /// GET - Get all supported currencies
  /// Returns: { currencies: Currency[] }
  static const String currencies = '/currencies';

  /// GET - Get single currency by code
  /// Returns: { currency: Currency }
  static String currencyByCode(String code) => '/currencies/$code';

  /// GET - Get current exchange rates
  /// Query params: ?base=USD
  /// Returns: { rates: { [code]: number }, lastUpdated: string }
  static const String exchangeRates = '/currencies/rates';

  /// POST - Convert amount between currencies
  /// Body: { amount: number, from: string, to: string }
  /// Returns: { convertedAmount: number, rate: number }
  static const String convertCurrency = '/currencies/convert';

  // ==================== Report Endpoints ====================

  /// GET - Get expense breakdown by category
  /// Headers: { Authorization: "Bearer <token>" }
  /// Query params: ?startDate=...&endDate=...
  /// Returns: { data: [{ category: string, amount: number, percentage: number }] }
  static const String reportExpenseByCategory = '/reports/expense-by-category';

  /// GET - Get income vs expense trend
  /// Headers: { Authorization: "Bearer <token>" }
  /// Query params: ?startDate=...&endDate=...&period=monthly
  /// Returns: { data: [{ period: string, income: number, expense: number }] }
  static const String reportIncomeVsExpense = '/reports/income-vs-expense';

  /// GET - Get monthly spending comparison
  /// Headers: { Authorization: "Bearer <token>" }
  /// Query params: ?months=6
  /// Returns: { data: [{ month: string, amount: number }] }
  static const String reportMonthlyComparison = '/reports/monthly-comparison';

  /// GET - Get account balances summary
  /// Headers: { Authorization: "Bearer <token>" }
  /// Returns: { data: [{ account: string, balance: number, currency: string }] }
  static const String reportAccountBalances = '/reports/account-balances';

  /// GET - Get spending trends by category over time
  /// Headers: { Authorization: "Bearer <token>" }
  /// Query params: ?category=...&months=6
  /// Returns: { data: [{ month: string, amount: number }] }
  static const String reportSpendingTrends = '/reports/spending-trends';
}
