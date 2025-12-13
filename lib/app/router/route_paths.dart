/// Route paths for the application
///
/// Contains all route paths used in navigation.
/// Use these constants instead of hardcoded strings.
class RoutePaths {
  // Private constructor to prevent instantiation
  RoutePaths._();

  // ==================== Authentication ====================
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // ==================== Main Navigation ====================
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String accounts = '/accounts';
  static const String reports = '/reports';

  // ==================== Transactions ====================
  static const String transactionDetail = '/transactions/:id';
  static const String addTransaction = '/transactions/add';
  static const String editTransaction = '/transactions/:id/edit';

  // ==================== Accounts ====================
  static const String accountDetail = '/accounts/:id';
  static const String addAccount = '/accounts/add';
  static const String editAccount = '/accounts/:id/edit';

  // ==================== Categories ====================
  static const String categories = '/categories';
  static const String addCategory = '/categories/add';
  static const String editCategory = '/categories/:id/edit';

  // ==================== Budgets ====================
  static const String budgets = '/budgets';
  static const String budgetDetail = '/budgets/:id';
  static const String addBudget = '/budgets/add';
  static const String editBudget = '/budgets/:id/edit';

  // ==================== Recurring Transactions ====================
  static const String recurringTransactions = '/recurring';
  static const String recurringTransactionDetail = '/recurring/:id';
  static const String addRecurringTransaction = '/recurring/add';
  static const String editRecurringTransaction = '/recurring/:id/edit';

  // ==================== Reports ====================
  static const String expenseBreakdown = '/reports/expense-breakdown';
  static const String incomeTrends = '/reports/income-trends';
  static const String monthlyComparison = '/reports/monthly-comparison';

  // ==================== Settings ====================
  static const String settings = '/settings';
  static const String profile = '/settings/profile';
  static const String currency = '/settings/currency';
  static const String theme = '/settings/theme';
  static const String about = '/settings/about';

  // ==================== Helper Methods ====================

  /// Gets transaction detail path with id
  static String transactionDetailPath(String id) => '/transactions/$id';

  /// Gets edit transaction path with id
  static String editTransactionPath(String id) => '/transactions/$id/edit';

  /// Gets account detail path with id
  static String accountDetailPath(String id) => '/accounts/$id';

  /// Gets edit account path with id
  static String editAccountPath(String id) => '/accounts/$id/edit';

  /// Gets category edit path with id
  static String editCategoryPath(String id) => '/categories/$id/edit';

  /// Gets budget detail path with id
  static String budgetDetailPath(String id) => '/budgets/$id';

  /// Gets edit budget path with id
  static String editBudgetPath(String id) => '/budgets/$id/edit';

  /// Gets recurring transaction detail path with id
  static String recurringTransactionDetailPath(String id) => '/recurring/$id';

  /// Gets edit recurring transaction path with id
  static String editRecurringTransactionPath(String id) => '/recurring/$id/edit';
}
