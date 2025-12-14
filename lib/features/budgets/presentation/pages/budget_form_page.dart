import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/presentation/bloc/category_event.dart';
import '../../../categories/presentation/bloc/category_state.dart';
import '../../domain/entities/budget.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../widgets/budget_period_selector.dart';

/// Budget form page for adding or editing budgets
///
/// Provides a form to create new budgets or edit existing ones.
class BudgetFormPage extends StatefulWidget {
  final Budget? budget;
  final String userId;

  const BudgetFormPage({
    super.key,
    this.budget,
    this.userId = 'user_1', // TODO: Get from auth
  });

  @override
  State<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends State<BudgetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _alertThresholdController = TextEditingController();

  late BudgetPeriod _selectedPeriod;
  String? _selectedCategoryId;
  bool _isActive = true;
  bool _hasEndDate = false;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.budget != null) {
      _amountController.text = widget.budget!.amount.toString();
      _alertThresholdController.text = widget.budget!.alertThreshold.toString();
      _selectedPeriod = widget.budget!.period;
      _selectedCategoryId = widget.budget!.categoryId;
      _isActive = widget.budget!.isActive;
      _hasEndDate = widget.budget!.endDate != null;
      _endDate = widget.budget!.endDate;
    } else {
      _selectedPeriod = BudgetPeriod.monthly;
      _alertThresholdController.text = '80';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _alertThresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.budget != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BudgetBloc>()),
        BlocProvider(
          create: (_) => sl<CategoryBloc>()
            ..add(LoadCategories(userId: widget.userId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Budget' : 'Add Budget'),
        ),
        body: BlocListener<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is BudgetActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            } else if (state is BudgetError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Category selector
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoriesLoaded) {
                      final expenseCategories = state.categories
                          .where((c) => c.type == CategoryType.expense)
                          .toList();

                      return DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: expenseCategories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 16),

                // Amount field
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Budget Amount',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Period selector
                BudgetPeriodSelector(
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (period) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Alert threshold
                TextFormField(
                  controller: _alertThresholdController,
                  decoration: const InputDecoration(
                    labelText: 'Alert Threshold (%)',
                    border: OutlineInputBorder(),
                    helperText: 'Get notified when you reach this percentage',
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a threshold';
                    }
                    final threshold = double.tryParse(value);
                    if (threshold == null || threshold < 0 || threshold > 100) {
                      return 'Threshold must be between 0 and 100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Active toggle
                SwitchListTile(
                  title: const Text('Active'),
                  subtitle: const Text('Enable or disable this budget'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // End date toggle
                SwitchListTile(
                  title: const Text('Set End Date'),
                  subtitle: const Text('Budget will expire on this date'),
                  value: _hasEndDate,
                  onChanged: (value) {
                    setState(() {
                      _hasEndDate = value;
                      if (!value) _endDate = null;
                    });
                  },
                ),
                if (_hasEndDate) ...[
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text('End Date'),
                    subtitle: Text(
                      _endDate != null
                          ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                          : 'Not set',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                  ),
                ],
                const SizedBox(height: 24),

                // Save button
                ElevatedButton(
                  onPressed: _saveBudget,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(isEditing ? 'Update Budget' : 'Create Budget'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveBudget() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final amount = double.parse(_amountController.text);
    final alertThreshold = double.parse(_alertThresholdController.text);
    final now = DateTime.now();

    final budget = Budget(
      id: widget.budget?.id ?? '',
      userId: widget.userId,
      categoryId: _selectedCategoryId!,
      amount: amount,
      currency: 'USD', // TODO: Get from user settings
      period: _selectedPeriod,
      startDate: widget.budget?.startDate ?? now,
      endDate: _hasEndDate ? _endDate : null,
      alertThreshold: alertThreshold,
      isActive: _isActive,
      createdAt: widget.budget?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.budget != null) {
      context.read<BudgetBloc>().add(UpdateBudget(budget: budget));
    } else {
      context.read<BudgetBloc>().add(CreateBudget(budget: budget));
    }
  }
}
