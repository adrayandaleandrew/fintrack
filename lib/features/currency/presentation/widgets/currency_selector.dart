import 'package:finance_tracker/features/currency/domain/entities/currency.dart';
import 'package:flutter/material.dart';

/// Reusable currency selector widget
///
/// Dropdown for selecting currencies in forms.
class CurrencySelector extends StatelessWidget {
  final List<Currency> currencies;
  final String? selectedCurrency;
  final ValueChanged<String?> onChanged;
  final String? labelText;
  final String? errorText;

  const CurrencySelector({
    super.key,
    required this.currencies,
    required this.selectedCurrency,
    required this.onChanged,
    this.labelText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCurrency,
      decoration: InputDecoration(
        labelText: labelText ?? 'Currency',
        errorText: errorText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.attach_money),
      ),
      items: currencies.map((currency) {
        return DropdownMenuItem<String>(
          value: currency.code,
          child: Row(
            children: [
              Text(
                currency.flag,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Text(currency.code),
              const SizedBox(width: 8),
              Text(
                currency.symbol,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a currency';
        }
        return null;
      },
    );
  }
}

/// Compact currency chip widget
///
/// Shows currency code and symbol in a chip format.
class CurrencyChip extends StatelessWidget {
  final String currencyCode;
  final String currencySymbol;
  final String? flag;
  final VoidCallback? onTap;

  const CurrencyChip({
    super.key,
    required this.currencyCode,
    required this.currencySymbol,
    this.flag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (flag != null) ...[
              Text(flag!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
            ],
            Text(
              currencyCode,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              currencySymbol,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
