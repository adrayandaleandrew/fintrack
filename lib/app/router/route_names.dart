/// Route names for the application
///
/// Contains all route names used in navigation.
/// Use these constants for named navigation.
class RouteNames {
  // Private constructor to prevent instantiation
  RouteNames._();

  // ==================== Authentication ====================
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';

  // ==================== Main Navigation ====================
  static const String dashboard = 'dashboard';
  static const String transactions = 'transactions';
  static const String accounts = 'accounts';
  static const String reports = 'reports';

  // ==================== Transactions ====================
  static const String transactionDetail = 'transaction-detail';
  static const String addTransaction = 'add-transaction';
  static const String editTransaction = 'edit-transaction';

  // ==================== Accounts ====================
  static const String accountDetail = 'account-detail';
  static const String addAccount = 'add-account';
  static const String editAccount = 'edit-account';

  // ==================== Categories ====================
  static const String categories = 'categories';
  static const String addCategory = 'add-category';
  static const String editCategory = 'edit-category';

  // ==================== Budgets ====================
  static const String budgets = 'budgets';
  static const String budgetDetail = 'budget-detail';
  static const String addBudget = 'add-budget';
  static const String editBudget = 'edit-budget';

  // ==================== Recurring Transactions ====================
  static const String recurringTransactions = 'recurring-transactions';
  static const String recurringTransactionDetail = 'recurring-transaction-detail';
  static const String addRecurringTransaction = 'add-recurring-transaction';
  static const String editRecurringTransaction = 'edit-recurring-transaction';

  // ==================== Reports ====================
  static const String expenseBreakdown = 'expense-breakdown';
  static const String incomeTrends = 'income-trends';
  static const String monthlyComparison = 'monthly-comparison';

  // ==================== Settings ====================
  static const String settings = 'settings';
  static const String profile = 'profile';
  static const String currency = 'currency';
  static const String theme = 'theme';
  static const String about = 'about';
}
