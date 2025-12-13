import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/category.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import 'category_form_page.dart';

/// Page displaying list of categories
///
/// Shows categories grouped by type (Income/Expense).
/// Separates default and custom categories.
class CategoryListPage extends StatelessWidget {
  final String userId;

  const CategoryListPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CategoryBloc>()
        ..add(LoadCategories(userId: userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showInfoDialog(context),
              tooltip: 'Category info',
            ),
          ],
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
              // Reload categories after successful action
              context.read<CategoryBloc>().add(
                    LoadCategories(userId: userId),
                  );
            }
          },
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoriesLoaded) {
              if (state.categories.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildCategoryList(context, state);
            }

            if (state is CategoryError) {
              return _buildErrorState(context, state.message);
            }

            return _buildEmptyState(context);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _navigateToAddCategory(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Category'),
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, CategoriesLoaded state) {
    final incomeCategories = state.incomeCategories;
    final expenseCategories = state.expenseCategories;
    final customCategories = state.customCategories;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary card
        _buildSummaryCard(context, state),
        const SizedBox(height: 24),

        // Income categories
        _buildSectionHeader('Income Categories', incomeCategories.length),
        const SizedBox(height: 8),
        ...incomeCategories.map((category) => _buildCategoryCard(
              context,
              category,
            )),
        const SizedBox(height: 24),

        // Expense categories
        _buildSectionHeader('Expense Categories', expenseCategories.length),
        const SizedBox(height: 8),
        ...expenseCategories.map((category) => _buildCategoryCard(
              context,
              category,
            )),

        // Custom categories section (if any)
        if (customCategories.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader('Custom Categories', customCategories.length),
          const SizedBox(height: 8),
          ...customCategories.map((category) => _buildCategoryCard(
                context,
                category,
                showActions: true,
              )),
        ],

        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, CategoriesLoaded state) {
    final totalCategories = state.categories.length;
    final incomeCount = state.getCountByType(CategoryType.income);
    final expenseCount = state.getCountByType(CategoryType.expense);
    final customCount = state.customCategories.length;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Categories',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '$totalCategories',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Income', incomeCount, Colors.green),
                _buildStat('Expense', expenseCount, Colors.red),
                _buildStat('Custom', customCount, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Category category, {
    bool showActions = false,
  }) {
    final color = _parseColor(category.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIconData(category.icon),
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: category.isDefault
            ? Text(
                'Default Category',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              )
            : null,
        trailing: showActions && !category.isDefault
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _navigateToEditCategory(context, category),
                    tooltip: 'Edit category',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(context, category),
                    tooltip: 'Delete category',
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No categories yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first category to get started',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading categories',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CategoryBloc>().add(
                    LoadCategories(userId: userId),
                  );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Categories'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Default categories cannot be edited or deleted'),
            SizedBox(height: 8),
            Text('• Custom categories can be fully managed'),
            SizedBox(height: 8),
            Text('• Categories help organize your transactions'),
            SizedBox(height: 8),
            Text('• Each category has an icon and color for easy identification'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CategoryBloc>().add(
                    DeleteCategoryRequested(categoryId: category.id),
                  );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryFormPage(userId: userId),
      ),
    );
  }

  void _navigateToEditCategory(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryFormPage(
          userId: userId,
          category: category,
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (_) {
      return Colors.blue;
    }
  }

  IconData _getIconData(String iconName) {
    // Map common icon names to IconData
    final iconMap = {
      // Income icons
      'work': Icons.work,
      'computer': Icons.computer,
      'business_center': Icons.business_center,
      'trending_up': Icons.trending_up,
      'home': Icons.home,
      'card_giftcard': Icons.card_giftcard,
      'star': Icons.star,
      'receipt': Icons.receipt,
      'account_balance': Icons.account_balance,
      'attach_money': Icons.attach_money,

      // Expense icons
      'restaurant': Icons.restaurant,
      'shopping_cart': Icons.shopping_cart,
      'directions_car': Icons.directions_car,
      'shopping_bag': Icons.shopping_bag,
      'movie': Icons.movie,
      'receipt_long': Icons.receipt_long,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'flight': Icons.flight,
      'spa': Icons.spa,
      'security': Icons.security,
      'subscriptions': Icons.subscriptions,
      'home_repair_service': Icons.home_repair_service,
      'pets': Icons.pets,
      'more_horiz': Icons.more_horiz,
    };

    return iconMap[iconName] ?? Icons.category;
  }
}
