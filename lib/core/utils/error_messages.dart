/// Centralized error messages for consistent user experience
///
/// Following bestpractices.md principles:
/// - User-friendly, non-technical language
/// - Actionable guidance when possible
/// - Consistent tone and formatting
/// - Contextual help
class ErrorMessages {
  // Private constructor to prevent instantiation
  ErrorMessages._();

  // ============================================================================
  // Network & Server Errors
  // ============================================================================

  static const String networkError =
      'Unable to connect. Please check your internet connection and try again.';

  static const String serverError =
      'Something went wrong on our end. Please try again in a moment.';

  static const String timeoutError =
      'Request timed out. Please check your connection and try again.';

  static const String unexpectedError =
      'An unexpected error occurred. Please try again.';

  // ============================================================================
  // Authentication Errors
  // ============================================================================

  static const String invalidCredentials =
      'Email or password is incorrect. Please check and try again.';

  static const String emailAlreadyExists =
      'This email is already registered. Try logging in instead.';

  static const String authAccountNotFound =
      'No account found with this email. Please check or create a new account.';

  static const String sessionExpired =
      'Your session has expired. Please log in again.';

  static const String unauthorized =
      'You don\'t have permission to perform this action.';

  static const String weakPassword =
      'Password is too weak. Use at least 8 characters with letters and numbers.';

  // ============================================================================
  // Validation Errors
  // ============================================================================

  static const String requiredField = 'This field is required.';

  static const String invalidEmail =
      'Please enter a valid email address.';

  static const String invalidAmount =
      'Please enter a valid amount greater than zero.';

  static const String invalidDate =
      'Please select a valid date.';

  static const String futureDateNotAllowed =
      'Date cannot be in the future.';

  static const String nameEmpty =
      'Name cannot be empty.';

  static const String nameTooLong =
      'Name is too long. Please use 50 characters or less.';

  static const String descriptionEmpty =
      'Description is required.';

  // ============================================================================
  // Transaction Errors
  // ============================================================================

  static const String transactionNotFound =
      'Transaction not found. It may have been deleted.';

  static const String cannotDeleteTransaction =
      'Unable to delete transaction. Please try again.';

  static const String invalidTransactionType =
      'Please select a valid transaction type.';

  static const String accountRequired =
      'Please select an account.';

  static const String categoryRequired =
      'Please select a category.';

  static const String transferSameAccount =
      'Cannot transfer to the same account. Please choose a different account.';

  static const String transferAccountRequired =
      'Please select a destination account for the transfer.';

  static const String insufficientBalance =
      'Insufficient balance in account.';

  // ============================================================================
  // Account Errors
  // ============================================================================

  static const String accountNotFound =
      'Account not found. It may have been deleted.';

  static const String cannotDeleteAccount =
      'Unable to delete account. Please try again.';

  static const String accountNameExists =
      'An account with this name already exists.';

  static const String creditLimitRequired =
      'Credit limit is required for credit card accounts.';

  static const String creditLimitInvalid =
      'Credit limit must be greater than zero.';

  // ============================================================================
  // Budget Errors
  // ============================================================================

  static const String budgetNotFound =
      'Budget not found. It may have been deleted.';

  static const String cannotDeleteBudget =
      'Unable to delete budget. Please try again.';

  static const String budgetAlreadyExists =
      'A budget already exists for this category and period.';

  static const String budgetAmountRequired =
      'Budget amount is required.';

  static const String budgetAmountInvalid =
      'Budget amount must be greater than zero.';

  static const String budgetPeriodRequired =
      'Please select a budget period.';

  // ============================================================================
  // Category Errors
  // ============================================================================

  static const String categoryNotFound =
      'Category not found. It may have been deleted.';

  static const String cannotEditDefaultCategory =
      'Default categories cannot be edited. Create a custom category instead.';

  static const String cannotDeleteDefaultCategory =
      'Default categories cannot be deleted.';

  static const String cannotDeleteCategoryInUse =
      'This category is being used in transactions and cannot be deleted.';

  static const String categoryNameExists =
      'A category with this name already exists.';

  static const String categoryNameRequired =
      'Category name is required.';

  static const String categoryIconRequired =
      'Please select an icon for the category.';

  static const String categoryColorRequired =
      'Please select a color for the category.';

  // ============================================================================
  // Recurring Transaction Errors
  // ============================================================================

  static const String recurringTransactionNotFound =
      'Recurring transaction not found. It may have been deleted.';

  static const String cannotDeleteRecurringTransaction =
      'Unable to delete recurring transaction. Please try again.';

  static const String frequencyRequired =
      'Please select how often this transaction repeats.';

  static const String endDateBeforeStart =
      'End date must be after start date.';

  static const String maxOccurrencesInvalid =
      'Maximum occurrences must be greater than zero.';

  // ============================================================================
  // Currency Errors
  // ============================================================================

  static const String currencyNotFound =
      'Currency not found or not supported.';

  static const String exchangeRateUnavailable =
      'Exchange rate is temporarily unavailable. Using cached rate.';

  static const String currencyConversionFailed =
      'Unable to convert currency. Please try again.';

  static const String sameCurrencyConversion =
      'Source and target currencies are the same.';

  static const String invalidCurrencyCode =
      'Invalid currency code. Please select a valid currency.';

  // ============================================================================
  // Cache & Storage Errors
  // ============================================================================

  static const String cacheError =
      'Unable to access local data. Please restart the app.';

  static const String storageError =
      'Unable to save data. Please check available storage space.';

  static const String dataLoadError =
      'Unable to load data. Please try again.';

  // ============================================================================
  // Empty States (Information, not errors)
  // ============================================================================

  static const String noTransactions =
      'No transactions yet. Add your first transaction to start tracking.';

  static const String noAccounts =
      'No accounts found. Create an account to get started.';

  static const String noBudgets =
      'No budgets set up. Create a budget to track your spending.';

  static const String noCategories =
      'No categories found.';

  static const String noRecurringTransactions =
      'No recurring transactions set up.';

  static const String noSearchResults =
      'No results found. Try different search terms.';

  static const String noFilterResults =
      'No transactions match the selected filters.';

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Get error message from failure object
  static String getErrorMessage(String? failureMessage) {
    if (failureMessage == null || failureMessage.isEmpty) {
      return unexpectedError;
    }

    // Map common failure messages to user-friendly ones
    final message = failureMessage.toLowerCase();

    if (message.contains('network') || message.contains('connection')) {
      return networkError;
    }
    if (message.contains('server') || message.contains('500')) {
      return serverError;
    }
    if (message.contains('timeout')) {
      return timeoutError;
    }
    if (message.contains('unauthorized') || message.contains('401')) {
      return unauthorized;
    }
    if (message.contains('session') || message.contains('expired')) {
      return sessionExpired;
    }
    if (message.contains('not found') || message.contains('404')) {
      return 'Item not found. It may have been deleted.';
    }

    // Return original message if no mapping found
    // This allows custom messages from use cases to pass through
    return failureMessage;
  }

  /// Get contextual help text for common errors
  static String? getHelpText(String errorMessage) {
    final message = errorMessage.toLowerCase();

    if (message.contains('network') || message.contains('connection')) {
      return 'Check your WiFi or mobile data and try again.';
    }
    if (message.contains('password')) {
      return 'Use at least 8 characters with a mix of letters and numbers.';
    }
    if (message.contains('email')) {
      return 'Make sure your email is in the format: name@example.com';
    }

    return null;
  }
}
