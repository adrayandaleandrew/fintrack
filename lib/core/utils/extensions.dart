import 'package:intl/intl.dart';

/// Extension methods for DateTime to make date operations more convenient.
extension DateTimeExtension on DateTime {
  /// Formats the date as 'MMM dd, yyyy' (e.g., "Jan 15, 2024").
  String toFormattedString() {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Formats the date as 'yyyy-MM-dd' (e.g., "2024-01-15").
  String toIso8601DateString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Formats the date and time as 'MMM dd, yyyy hh:mm a' (e.g., "Jan 15, 2024 02:30 PM").
  String toFormattedDateTime() {
    return DateFormat('MMM dd, yyyy hh:mm a').format(this);
  }

  /// Formats the time as 'hh:mm a' (e.g., "02:30 PM").
  String toFormattedTime() {
    return DateFormat('hh:mm a').format(this);
  }

  /// Returns true if this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns true if this date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns true if this date is in the current month.
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Returns true if this date is in the current year.
  bool get isThisYear {
    return year == DateTime.now().year;
  }

  /// Returns a new DateTime with time set to midnight (start of day).
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Returns a new DateTime with time set to 23:59:59.999 (end of day).
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }
}

/// Extension methods for double to make amount calculations more convenient.
extension DoubleExtension on double {
  /// Formats the double as a currency string with 2 decimal places.
  ///
  /// Example: 1234.5 -> "1,234.50"
  String toCurrency() {
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 2);
    return formatter.format(this);
  }

  /// Formats the double as a percentage string.
  ///
  /// Example: 0.85 -> "85%"
  String toPercentage({int decimalPlaces = 0}) {
    final percentage = this * 100;
    return '${percentage.toStringAsFixed(decimalPlaces)}%';
  }

  /// Rounds to a specific number of decimal places.
  double roundToDecimalPlaces(int places) {
    final mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }

  /// Returns absolute value of the number.
  double get abs => this < 0 ? -this : this;
}

/// Extension methods for int to make calculations more convenient.
extension IntExtension on int {
  /// Returns a duration of this many days.
  Duration get days => Duration(days: this);

  /// Returns a duration of this many hours.
  Duration get hours => Duration(hours: this);

  /// Returns a duration of this many minutes.
  Duration get minutes => Duration(minutes: this);

  /// Returns a duration of this many seconds.
  Duration get seconds => Duration(seconds: this);
}

/// Extension methods for String to make text operations more convenient.
extension StringExtension on String {
  /// Capitalizes the first letter of the string.
  ///
  /// Example: "hello" -> "Hello"
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Capitalizes the first letter of each word.
  ///
  /// Example: "hello world" -> "Hello World"
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Returns true if the string is a valid email format.
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Truncates the string to a maximum length and adds ellipsis if needed.
  ///
  /// Example: "Hello World".truncate(8) -> "Hello..."
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return substring(0, maxLength - ellipsis.length) + ellipsis;
  }

  /// Removes all whitespace from the string.
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Returns true if the string is null or empty.
  bool get isNullOrEmpty => isEmpty;
}

/// Extension methods for List to make list operations more convenient.
extension ListExtension<T> on List<T> {
  /// Returns the first element or null if the list is empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or null if the list is empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Groups list elements by a key function.
  ///
  /// Example: groupBy((transaction) => transaction.category)
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Sums numeric values in the list.
  ///
  /// Example: [1, 2, 3].sum((n) => n) -> 6
  double sum(double Function(T) getValue) {
    if (isEmpty) return 0;
    return fold(0, (sum, element) => sum + getValue(element));
  }
}

/// Helper function for exponentiation (pow function).
double pow(double base, int exponent) {
  if (exponent == 0) return 1.0;
  double result = 1.0;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
