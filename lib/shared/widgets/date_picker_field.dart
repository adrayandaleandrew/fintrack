import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date picker field widget
///
/// Text field that opens a date picker when tapped.
class DatePickerField extends StatefulWidget {
  /// Selected date
  final DateTime? selectedDate;

  /// Date changed callback
  final ValueChanged<DateTime> onDateChanged;

  /// Field label
  final String label;

  /// Hint text
  final String? hint;

  /// First date (minimum)
  final DateTime? firstDate;

  /// Last date (maximum)
  final DateTime? lastDate;

  /// Enable/disable field
  final bool enabled;

  /// Validator function
  final String? Function(DateTime?)? validator;

  const DatePickerField({
    super.key,
    this.selectedDate,
    required this.onDateChanged,
    this.label = 'Date',
    this.hint,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.validator,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedDate != null
          ? DateFormat('MMM dd, yyyy').format(widget.selectedDate!)
          : '',
    );
  }

  @override
  void didUpdateWidget(DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _controller.text = widget.selectedDate != null
          ? DateFormat('MMM dd, yyyy').format(widget.selectedDate!)
          : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (pickedDate != null) {
      widget.onDateChanged(pickedDate);
      _controller.text = DateFormat('MMM dd, yyyy').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint ?? 'Select date',
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: widget.selectedDate != null && widget.enabled
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.onDateChanged(DateTime.now());
                  _controller.clear();
                },
              )
            : null,
      ),
      readOnly: true,
      enabled: widget.enabled,
      onTap: widget.enabled ? () => _selectDate(context) : null,
      validator: widget.validator != null
          ? (value) => widget.validator!(widget.selectedDate)
          : null,
    );
  }
}

/// Date range picker field widget
///
/// Field for selecting a date range.
class DateRangePickerField extends StatefulWidget {
  /// Selected date range
  final DateTimeRange? selectedRange;

  /// Date range changed callback
  final ValueChanged<DateTimeRange> onRangeChanged;

  /// Field label
  final String label;

  /// Hint text
  final String? hint;

  /// First date (minimum)
  final DateTime? firstDate;

  /// Last date (maximum)
  final DateTime? lastDate;

  /// Enable/disable field
  final bool enabled;

  const DateRangePickerField({
    super.key,
    this.selectedRange,
    required this.onRangeChanged,
    this.label = 'Date Range',
    this.hint,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  @override
  State<DateRangePickerField> createState() => _DateRangePickerFieldState();
}

class _DateRangePickerFieldState extends State<DateRangePickerField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedRange != null
          ? _formatDateRange(widget.selectedRange!)
          : '',
    );
  }

  @override
  void didUpdateWidget(DateRangePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedRange != oldWidget.selectedRange) {
      _controller.text = widget.selectedRange != null
          ? _formatDateRange(widget.selectedRange!)
          : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDateRange(DateTimeRange range) {
    final start = DateFormat('MMM dd, yyyy').format(range.start);
    final end = DateFormat('MMM dd, yyyy').format(range.end);
    return '$start - $end';
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: widget.selectedRange,
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (pickedRange != null) {
      widget.onRangeChanged(pickedRange);
      _controller.text = _formatDateRange(pickedRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint ?? 'Select date range',
        prefixIcon: const Icon(Icons.date_range),
        suffixIcon: widget.selectedRange != null && widget.enabled
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                },
              )
            : null,
      ),
      readOnly: true,
      enabled: widget.enabled,
      onTap: widget.enabled ? () => _selectDateRange(context) : null,
    );
  }
}

/// Quick date filter chips
///
/// Pre-defined date range filters (Today, This Week, This Month, etc.)
class DateFilterChips extends StatelessWidget {
  /// Selected filter
  final DateFilter selectedFilter;

  /// Filter changed callback
  final ValueChanged<DateFilter> onFilterChanged;

  const DateFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: DateFilter.values.map((filter) {
        return ChoiceChip(
          label: Text(filter.label),
          selected: selectedFilter == filter,
          onSelected: (selected) {
            if (selected) {
              onFilterChanged(filter);
            }
          },
        );
      }).toList(),
    );
  }
}

/// Date filter options
enum DateFilter {
  today,
  yesterday,
  thisWeek,
  lastWeek,
  thisMonth,
  lastMonth,
  thisYear,
  custom,
}

extension DateFilterExtension on DateFilter {
  String get label {
    switch (this) {
      case DateFilter.today:
        return 'Today';
      case DateFilter.yesterday:
        return 'Yesterday';
      case DateFilter.thisWeek:
        return 'This Week';
      case DateFilter.lastWeek:
        return 'Last Week';
      case DateFilter.thisMonth:
        return 'This Month';
      case DateFilter.lastMonth:
        return 'Last Month';
      case DateFilter.thisYear:
        return 'This Year';
      case DateFilter.custom:
        return 'Custom';
    }
  }

  DateTimeRange get dateRange {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (this) {
      case DateFilter.today:
        return DateTimeRange(
          start: today,
          end: today.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
        );
      case DateFilter.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        return DateTimeRange(
          start: yesterday,
          end: yesterday.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
        );
      case DateFilter.thisWeek:
        final weekStart = today.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 7)).subtract(const Duration(seconds: 1));
        return DateTimeRange(start: weekStart, end: weekEnd);
      case DateFilter.lastWeek:
        final lastWeekStart = today.subtract(Duration(days: now.weekday + 6));
        final lastWeekEnd = lastWeekStart.add(const Duration(days: 7)).subtract(const Duration(seconds: 1));
        return DateTimeRange(start: lastWeekStart, end: lastWeekEnd);
      case DateFilter.thisMonth:
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 1).subtract(const Duration(seconds: 1));
        return DateTimeRange(start: monthStart, end: monthEnd);
      case DateFilter.lastMonth:
        final lastMonthStart = DateTime(now.year, now.month - 1, 1);
        final lastMonthEnd = DateTime(now.year, now.month, 1).subtract(const Duration(seconds: 1));
        return DateTimeRange(start: lastMonthStart, end: lastMonthEnd);
      case DateFilter.thisYear:
        final yearStart = DateTime(now.year, 1, 1);
        final yearEnd = DateTime(now.year + 1, 1, 1).subtract(const Duration(seconds: 1));
        return DateTimeRange(start: yearStart, end: yearEnd);
      case DateFilter.custom:
        return DateTimeRange(start: today, end: today);
    }
  }
}
