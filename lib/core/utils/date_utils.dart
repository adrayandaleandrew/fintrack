/// Utility class for date-related operations.
///
/// Provides common date calculations and formatting helpers used throughout the app.
class AppDateUtils {
  /// Returns the start of the day (midnight) for a given date.
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns the end of the day (23:59:59.999) for a given date.
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Returns the start of the current month.
  static DateTime startOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month, 1);
  }

  /// Returns the end of the current month.
  static DateTime endOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    final nextMonth = d.month == 12
        ? DateTime(d.year + 1, 1, 1)
        : DateTime(d.year, d.month + 1, 1);
    return nextMonth.subtract(const Duration(microseconds: 1));
  }

  /// Returns the start of the current week (Monday).
  static DateTime startOfWeek([DateTime? date]) {
    final d = date ?? DateTime.now();
    final daysToMonday = d.weekday - DateTime.monday;
    return startOfDay(d.subtract(Duration(days: daysToMonday)));
  }

  /// Returns the end of the current week (Sunday).
  static DateTime endOfWeek([DateTime? date]) {
    final d = date ?? DateTime.now();
    final daysToSunday = DateTime.sunday - d.weekday;
    return endOfDay(d.add(Duration(days: daysToSunday)));
  }

  /// Returns the start of the current year.
  static DateTime startOfYear([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, 1, 1);
  }

  /// Returns the end of the current year.
  static DateTime endOfYear([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, 12, 31, 23, 59, 59, 999);
  }

  /// Checks if two dates are on the same day.
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Checks if a date is today.
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Checks if a date is yesterday.
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Checks if a date is in the current month.
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Checks if a date is in the current year.
  static bool isThisYear(DateTime date) {
    return date.year == DateTime.now().year;
  }

  /// Returns the number of days in a given month.
  static int daysInMonth(int year, int month) {
    // Month 0 of next month is the last day of current month
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    return lastDayOfMonth.day;
  }

  /// Adds months to a date, handling edge cases properly.
  ///
  /// For example: Adding 1 month to Jan 31 gives Feb 28 (or 29 in leap year).
  static DateTime addMonths(DateTime date, int months) {
    final targetMonth = date.month + months;
    final targetYear = date.year + (targetMonth - 1) ~/ 12;
    final normalizedMonth = ((targetMonth - 1) % 12) + 1;

    // Handle day overflow (e.g., Jan 31 + 1 month = Feb 28/29)
    final maxDays = daysInMonth(targetYear, normalizedMonth);
    final targetDay = date.day > maxDays ? maxDays : date.day;

    return DateTime(
      targetYear,
      normalizedMonth,
      targetDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  /// Gets a date range for a given period.
  ///
  /// Returns [startDate, endDate] for the period containing the given date.
  static List<DateTime> getDateRangeForPeriod(String period, [DateTime? date]) {
    final d = date ?? DateTime.now();

    switch (period.toLowerCase()) {
      case 'daily':
      case 'day':
        return [startOfDay(d), endOfDay(d)];

      case 'weekly':
      case 'week':
        return [startOfWeek(d), endOfWeek(d)];

      case 'monthly':
      case 'month':
        return [startOfMonth(d), endOfMonth(d)];

      case 'yearly':
      case 'year':
        return [startOfYear(d), endOfYear(d)];

      default:
        // Default to current month
        return [startOfMonth(d), endOfMonth(d)];
    }
  }

  /// Calculates the difference in days between two dates (ignoring time).
  static int daysBetween(DateTime start, DateTime end) {
    final startDate = startOfDay(start);
    final endDate = startOfDay(end);
    return endDate.difference(startDate).inDays;
  }

  /// Calculates the difference in months between two dates.
  static int monthsBetween(DateTime start, DateTime end) {
    return (end.year - start.year) * 12 + end.month - start.month;
  }

  /// Formats a date as a readable string based on how recent it is.
  ///
  /// Examples:
  /// - Today -> "Today"
  /// - Yesterday -> "Yesterday"
  /// - This week -> "Monday", "Tuesday", etc.
  /// - This year -> "Jan 15", "Feb 3", etc.
  /// - Older -> "Jan 15, 2023"
  static String formatRelative(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else if (isThisYear(date)) {
      // Within this year: "Jan 15" or "Monday" if within a week
      final daysAgo = DateTime.now().difference(date).inDays;
      if (daysAgo <= 7) {
        return _getWeekdayName(date.weekday);
      }
      return _getMonthAbbreviation(date.month) + ' ${date.day}';
    } else {
      // Different year: "Jan 15, 2023"
      return '${_getMonthAbbreviation(date.month)} ${date.day}, ${date.year}';
    }
  }

  static String _getWeekdayName(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  static String _getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
