/// Utility class for input validation.
///
/// Provides validators for common input fields in the finance tracker app.
class Validators {
  /// Validates an email address.
  ///
  /// Returns null if valid, error message if invalid.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates a password.
  ///
  /// Password must be at least [minLength] characters (default 8).
  /// Returns null if valid, error message if invalid.
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Validates that a password confirmation matches the original password.
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates a required text field.
  ///
  /// Returns null if not empty, error message if empty.
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates a currency amount.
  ///
  /// Amount must be greater than zero.
  /// Returns null if valid, error message if invalid.
  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }

    if (amount <= 0) {
      return 'Amount must be greater than zero';
    }

    return null;
  }

  /// Validates a positive number (can be zero).
  static String? positiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < 0) {
      return 'Number must be positive';
    }

    return null;
  }

  /// Validates that a string has a minimum length.
  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.length < length) {
      return '${fieldName ?? 'This field'} must be at least $length characters';
    }

    return null;
  }

  /// Validates that a string has a maximum length.
  static String? maxLength(String? value, int length, {String? fieldName}) {
    if (value == null) return null;

    if (value.length > length) {
      return '${fieldName ?? 'This field'} must not exceed $length characters';
    }

    return null;
  }

  /// Validates an account name.
  ///
  /// Must be between 1 and 50 characters.
  static String? accountName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account name is required';
    }

    if (value.length > 50) {
      return 'Account name must not exceed 50 characters';
    }

    return null;
  }

  /// Validates a category name.
  ///
  /// Must be between 1 and 30 characters.
  static String? categoryName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Category name is required';
    }

    if (value.length > 30) {
      return 'Category name must not exceed 30 characters';
    }

    return null;
  }

  /// Validates a transaction description.
  ///
  /// Optional, but if provided must not exceed 200 characters.
  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Description is optional
    }

    if (value.length > 200) {
      return 'Description must not exceed 200 characters';
    }

    return null;
  }

  /// Validates a budget threshold percentage.
  ///
  /// Must be between 0 and 1 (e.g., 0.8 for 80%).
  static String? budgetThreshold(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Threshold is required';
    }

    final threshold = double.tryParse(value);
    if (threshold == null) {
      return 'Please enter a valid number';
    }

    if (threshold < 0 || threshold > 1) {
      return 'Threshold must be between 0 and 1';
    }

    return null;
  }

  /// Validates that a date is not in the future.
  static String? notFutureDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }

    final now = DateTime.now();
    if (date.isAfter(now)) {
      return 'Date cannot be in the future';
    }

    return null;
  }

  /// Validates that an end date is after a start date.
  static String? dateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return null; // Individual validation will catch this
    }

    if (endDate.isBefore(startDate)) {
      return 'End date must be after start date';
    }

    return null;
  }

  /// Combines multiple validators.
  ///
  /// Returns the first error message encountered, or null if all pass.
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
