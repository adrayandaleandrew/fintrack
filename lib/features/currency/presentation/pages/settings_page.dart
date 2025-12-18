import 'package:finance_tracker/features/currency/presentation/bloc/currency_bloc.dart';
import 'package:finance_tracker/features/currency/presentation/bloc/currency_event.dart';
import 'package:finance_tracker/features/currency/presentation/bloc/currency_state.dart';
import 'package:finance_tracker/shared/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings page for user preferences
///
/// Allows users to configure base currency and other app settings.
class SettingsPage extends StatefulWidget {
  final String userId;

  const SettingsPage({
    super.key,
    required this.userId,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    // Load currencies and base currency
    context.read<CurrencyBloc>().add(const LoadCurrencies());
    context.read<CurrencyBloc>().add(LoadBaseCurrency(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: BlocConsumer<CurrencyBloc, CurrencyState>(
        listener: (context, state) {
          if (state is BaseCurrencyUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CurrencyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is BaseCurrencyLoaded) {
            setState(() {
              _selectedCurrency = state.currencyCode;
            });
          }
        },
        builder: (context, state) {
          if (state is CurrencyLoading && _selectedCurrency == null) {
            return const Center(child: LoadingIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Currency Settings Section
              _buildSectionHeader('Currency'),
              const SizedBox(height: 8),
              _buildBaseCurrencyTile(context, state),
              const SizedBox(height: 24),

              // About Section
              _buildSectionHeader('About'),
              const SizedBox(height: 8),
              _buildAboutTile(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildBaseCurrencyTile(BuildContext context, CurrencyState state) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.attach_money),
        title: const Text('Base Currency'),
        subtitle: Text(
          _selectedCurrency != null
              ? 'Currently: $_selectedCurrency'
              : 'Select your preferred currency',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showCurrencyPicker(context, state),
      ),
    );
  }

  Widget _buildAboutTile() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: const Text('About'),
        subtitle: const Text('Finance Tracker v1.0.0'),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationName: 'Finance Tracker',
            applicationVersion: '1.0.0',
            applicationIcon: const Icon(Icons.account_balance_wallet, size: 48),
            children: [
              const Text(
                'A comprehensive personal finance management application.',
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, CurrencyState state) {
    // Get currencies from state
    List<String> currencies = [];
    if (state is CurrenciesLoaded) {
      currencies = state.currencies.map((c) => c.code).toList();
    }

    if (currencies.isEmpty) {
      // Load currencies if not loaded
      context.read<CurrencyBloc>().add(const LoadCurrencies());
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (modalContext) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Base Currency',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = currency == _selectedCurrency;

                  return ListTile(
                    title: Text(currency),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      // Update base currency
                      context.read<CurrencyBloc>().add(
                            UpdateBaseCurrencyRequested(
                              userId: widget.userId,
                              currencyCode: currency,
                            ),
                          );
                      Navigator.pop(modalContext);
                      setState(() {
                        _selectedCurrency = currency;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
