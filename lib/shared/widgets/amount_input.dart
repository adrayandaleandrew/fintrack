import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/validators.dart';

/// Amount input widget
///
/// Specialized text field for entering currency amounts.
/// Includes proper formatting and validation.
class AmountInput extends StatelessWidget {
  /// Text editing controller
  final TextEditingController controller;

  /// Field label
  final String label;

  /// Currency symbol
  final String currencySymbol;

  /// Validation function
  final String? Function(String?)? validator;

  /// Enable/disable field
  final bool enabled;

  /// On changed callback
  final ValueChanged<String>? onChanged;

  /// Autofocus
  final bool autofocus;

  const AmountInput({
    super.key,
    required this.controller,
    this.label = 'Amount',
    this.currencySymbol = '\$',
    this.validator,
    this.enabled = true,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: '$currencySymbol ',
        prefixStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: validator ?? Validators.amount,
      enabled: enabled,
      onChanged: onChanged,
      autofocus: autofocus,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

/// Large amount display widget
///
/// Displays a large, prominent currency amount.
/// Use this for main balances and totals.
class AmountDisplay extends StatelessWidget {
  /// Amount to display
  final double amount;

  /// Currency symbol
  final String currencySymbol;

  /// Text color
  final Color? color;

  /// Font size
  final double? fontSize;

  /// Whether to show sign (+/-)
  final bool showSign;

  const AmountDisplay({
    super.key,
    required this.amount,
    this.currencySymbol = '\$',
    this.color,
    this.fontSize,
    this.showSign = false,
  });

  /// Large amount display
  const AmountDisplay.large({
    super.key,
    required this.amount,
    this.currencySymbol = '\$',
    this.color,
    this.showSign = false,
  }) : fontSize = 32;

  /// Medium amount display
  const AmountDisplay.medium({
    super.key,
    required this.amount,
    this.currencySymbol = '\$',
    this.color,
    this.showSign = false,
  }) : fontSize = 24;

  /// Small amount display
  const AmountDisplay.small({
    super.key,
    required this.amount,
    this.currencySymbol = '\$',
    this.color,
    this.showSign = false,
  }) : fontSize = 16;

  @override
  Widget build(BuildContext context) {
    final sign = amount >= 0 ? '+' : '-';
    final absAmount = amount.abs();
    final formattedAmount = absAmount.toStringAsFixed(2);

    return Text(
      showSign
          ? '$sign$currencySymbol$formattedAmount'
          : '$currencySymbol$formattedAmount',
      style: TextStyle(
        fontSize: fontSize ?? 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Colored amount display
///
/// Displays amount with color based on positive/negative value.
class ColoredAmountDisplay extends StatelessWidget {
  /// Amount to display
  final double amount;

  /// Currency symbol
  final String currencySymbol;

  /// Font size
  final double? fontSize;

  /// Whether to show sign (+/-)
  final bool showSign;

  /// Positive color (default: green)
  final Color? positiveColor;

  /// Negative color (default: red)
  final Color? negativeColor;

  const ColoredAmountDisplay({
    super.key,
    required this.amount,
    this.currencySymbol = '\$',
    this.fontSize,
    this.showSign = true,
    this.positiveColor,
    this.negativeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = amount >= 0
        ? (positiveColor ?? Colors.green)
        : (negativeColor ?? Colors.red);

    return AmountDisplay(
      amount: amount,
      currencySymbol: currencySymbol,
      color: color,
      fontSize: fontSize,
      showSign: showSign,
    );
  }
}

/// Transaction type amount display
///
/// Displays amount with color based on transaction type.
class TransactionAmountDisplay extends StatelessWidget {
  /// Amount to display
  final double amount;

  /// Transaction type (income, expense, transfer)
  final TransactionType type;

  /// Currency symbol
  final String currencySymbol;

  /// Font size
  final double? fontSize;

  const TransactionAmountDisplay({
    super.key,
    required this.amount,
    required this.type,
    this.currencySymbol = '\$',
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    bool showSign = true;

    switch (type) {
      case TransactionType.income:
        color = Colors.green;
        break;
      case TransactionType.expense:
        color = Colors.red;
        break;
      case TransactionType.transfer:
        color = Colors.blue;
        showSign = false;
        break;
    }

    return AmountDisplay(
      amount: amount,
      currencySymbol: currencySymbol,
      color: color,
      fontSize: fontSize,
      showSign: showSign,
    );
  }
}

/// Transaction type enum
enum TransactionType {
  income,
  expense,
  transfer,
}
