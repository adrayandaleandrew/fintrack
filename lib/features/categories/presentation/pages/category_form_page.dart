import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/category.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

/// Page for creating or editing a category
///
/// Provides form fields for category properties with validation.
/// Handles both create and update operations.
class CategoryFormPage extends StatefulWidget {
  final String userId;
  final Category? category; // Null for create, provided for edit

  const CategoryFormPage({
    super.key,
    required this.userId,
    this.category,
  });

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  CategoryType _selectedType = CategoryType.expense;
  String _selectedIcon = 'shopping_cart';
  String _selectedColor = '#F44336';

  // Icon options by category type
  final Map<CategoryType, List<Map<String, dynamic>>> _iconsByType = {
    CategoryType.income: [
      {'icon': Icons.work, 'name': 'work'},
      {'icon': Icons.computer, 'name': 'computer'},
      {'icon': Icons.business_center, 'name': 'business_center'},
      {'icon': Icons.trending_up, 'name': 'trending_up'},
      {'icon': Icons.home, 'name': 'home'},
      {'icon': Icons.card_giftcard, 'name': 'card_giftcard'},
      {'icon': Icons.star, 'name': 'star'},
      {'icon': Icons.attach_money, 'name': 'attach_money'},
    ],
    CategoryType.expense: [
      {'icon': Icons.restaurant, 'name': 'restaurant'},
      {'icon': Icons.shopping_cart, 'name': 'shopping_cart'},
      {'icon': Icons.shopping_bag, 'name': 'shopping_bag'},
      {'icon': Icons.directions_car, 'name': 'directions_car'},
      {'icon': Icons.movie, 'name': 'movie'},
      {'icon': Icons.local_hospital, 'name': 'local_hospital'},
      {'icon': Icons.school, 'name': 'school'},
      {'icon': Icons.flight, 'name': 'flight'},
      {'icon': Icons.home_repair_service, 'name': 'home_repair_service'},
      {'icon': Icons.pets, 'name': 'pets'},
      {'icon': Icons.spa, 'name': 'spa'},
      {'icon': Icons.receipt_long, 'name': 'receipt_long'},
    ],
  };

  // Color options
  final List<Map<String, dynamic>> _colors = [
    {'color': const Color(0xFFF44336), 'hex': '#F44336'}, // Red
    {'color': const Color(0xFF4CAF50), 'hex': '#4CAF50'}, // Green
    {'color': const Color(0xFF2196F3), 'hex': '#2196F3'}, // Blue
    {'color': const Color(0xFFFF9800), 'hex': '#FF9800'}, // Orange
    {'color': const Color(0xFF9C27B0), 'hex': '#9C27B0'}, // Purple
    {'color': const Color(0xFF00BCD4), 'hex': '#00BCD4'}, // Cyan
    {'color': const Color(0xFFFFEB3B), 'hex': '#FFEB3B'}, // Yellow
    {'color': const Color(0xFF795548), 'hex': '#795548'}, // Brown
    {'color': const Color(0xFF607D8B), 'hex': '#607D8B'}, // Blue Grey
    {'color': const Color(0xFFE91E63), 'hex': '#E91E63'}, // Pink
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _populateFormWithCategory();
    } else {
      // Set defaults for new category based on type
      _selectedIcon = _iconsByType[_selectedType]![0]['name'];
      _selectedColor = _selectedType.defaultColor;
    }
  }

  void _populateFormWithCategory() {
    final category = widget.category!;
    _nameController.text = category.name;
    _selectedType = category.type;
    _selectedIcon = category.icon;
    _selectedColor = category.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;
    final isDefaultCategory = widget.category?.isDefault ?? false;

    // Default categories cannot be edited
    if (isEdit && isDefaultCategory) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('View Category'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Default Category',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Default categories cannot be edited or deleted.',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => sl<CategoryBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Edit Category' : 'Add Category'),
        ),
        body: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CategoryActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final isLoading = state is CategoryLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildNameField(),
                  const SizedBox(height: 16),
                  if (!isEdit) ...[
                    _buildTypeSelector(),
                    const SizedBox(height: 16),
                  ],
                  _buildIconSelector(),
                  const SizedBox(height: 16),
                  _buildColorSelector(),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(isEdit ? 'Update Category' : 'Create Category'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Category Name',
        hintText: 'e.g., Food & Dining',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.text_fields),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a category name';
        }
        return null;
      },
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category Type',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTypeOption(
                CategoryType.income,
                'Income',
                Colors.green,
                Icons.arrow_downward,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeOption(
                CategoryType.expense,
                'Expense',
                Colors.red,
                Icons.arrow_upward,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeOption(
    CategoryType type,
    String label,
    Color color,
    IconData icon,
  ) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
          // Update icon to default for new type
          _selectedIcon = _iconsByType[type]![0]['name'];
          _selectedColor = type.defaultColor;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSelector() {
    final icons = _iconsByType[_selectedType]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Icon',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: icons.map((iconData) {
            final isSelected = _selectedIcon == iconData['name'];
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedIcon = iconData['name'];
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Icon(
                  iconData['icon'],
                  color: isSelected ? Colors.white : Colors.grey[700],
                  size: 28,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _colors.map((colorData) {
            final isSelected = _selectedColor == colorData['hex'];
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedColor = colorData['hex'];
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorData['color'],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.category == null) {
        // Create new category
        context.read<CategoryBloc>().add(
              CreateCategoryRequested(
                userId: widget.userId,
                name: _nameController.text.trim(),
                type: _selectedType,
                icon: _selectedIcon,
                color: _selectedColor,
              ),
            );
      } else {
        // Update existing category
        context.read<CategoryBloc>().add(
              UpdateCategoryRequested(
                categoryId: widget.category!.id,
                name: _nameController.text.trim(),
                icon: _selectedIcon,
                color: _selectedColor,
              ),
            );
      }
    }
  }
}
