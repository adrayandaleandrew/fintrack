import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';
import 'category_remote_datasource.dart';
import 'default_categories.dart';

/// Mock implementation of CategoryRemoteDataSource
///
/// Simulates API calls with in-memory storage.
/// Use this during development before real API is available.
class CategoryRemoteDataSourceMock implements CategoryRemoteDataSource {
  // In-memory storage for categories
  final List<CategoryModel> _categories = [];
  int _nextId = 1;

  CategoryRemoteDataSourceMock() {
    _initializeMockData();
  }

  /// Initializes mock data with default categories for test user
  void _initializeMockData() {
    // Initialize default categories for test user
    final defaultCategories = DefaultCategories.generateForUser('user_1');
    _categories.addAll(defaultCategories);
    _nextId = defaultCategories.length + 1;
  }

  @override
  Future<List<CategoryModel>> getCategories({
    required String userId,
    CategoryType? type,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    var categories = _categories.where((cat) => cat.userId == userId);

    if (type != null) {
      categories = categories.where((cat) => cat.type == type);
    }

    return categories.toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Future<CategoryModel> getCategoryById({
    required String categoryId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      throw NotFoundException('Category not found with ID: $categoryId');
    }
  }

  @override
  Future<CategoryModel> createCategory({
    required String userId,
    required String name,
    required CategoryType type,
    required String icon,
    required String color,
    int sortOrder = 0,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Validate
    if (name.trim().isEmpty) {
      throw ValidationException('Category name cannot be empty');
    }

    // Check for duplicate name
    final existingCategory = _categories.where(
      (cat) => cat.userId == userId && cat.name.toLowerCase() == name.toLowerCase(),
    );

    if (existingCategory.isNotEmpty) {
      throw ValidationException('A category with this name already exists');
    }

    final now = DateTime.now();

    final newCategory = CategoryModel(
      id: 'category_${_nextId++}',
      userId: userId,
      name: name,
      type: type,
      icon: icon,
      color: color,
      sortOrder: sortOrder,
      isDefault: false, // Custom categories are never default
      createdAt: now,
      updatedAt: now,
    );

    _categories.add(newCategory);
    return newCategory;
  }

  @override
  Future<CategoryModel> updateCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? color,
    int? sortOrder,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _categories.indexWhere((cat) => cat.id == categoryId);

    if (index == -1) {
      throw NotFoundException('Category not found with ID: $categoryId');
    }

    final category = _categories[index];

    // Cannot update default categories
    if (category.isDefault) {
      throw ValidationException('Default categories cannot be modified');
    }

    // Check for duplicate name if name is being updated
    if (name != null && name != category.name) {
      final existingCategory = _categories.where(
        (cat) =>
            cat.userId == category.userId &&
            cat.id != categoryId &&
            cat.name.toLowerCase() == name.toLowerCase(),
      );

      if (existingCategory.isNotEmpty) {
        throw ValidationException('A category with this name already exists');
      }
    }

    final updatedCategory = category.copyWith(
      name: name ?? category.name,
      icon: icon ?? category.icon,
      color: color ?? category.color,
      sortOrder: sortOrder ?? category.sortOrder,
      updatedAt: DateTime.now(),
    );

    _categories[index] = updatedCategory;
    return updatedCategory;
  }

  @override
  Future<void> deleteCategory({
    required String categoryId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _categories.indexWhere((cat) => cat.id == categoryId);

    if (index == -1) {
      throw NotFoundException('Category not found with ID: $categoryId');
    }

    final category = _categories[index];

    // Cannot delete default categories
    if (category.isDefault) {
      throw ValidationException('Default categories cannot be deleted');
    }

    // In a real implementation, check if category has transactions
    // For now, we'll just delete
    _categories.removeAt(index);
  }

  @override
  Future<List<CategoryModel>> getDefaultCategories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Return template default categories (no userId)
    return DefaultCategories.generateForUser('');
  }

  @override
  Future<List<CategoryModel>> initializeDefaultCategories({
    required String userId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if user already has default categories
    final existingDefaults = _categories.where(
      (cat) => cat.userId == userId && cat.isDefault,
    );

    if (existingDefaults.isNotEmpty) {
      throw ValidationException('Default categories already initialized for this user');
    }

    // Generate default categories for user
    final defaultCategories = DefaultCategories.generateForUser(userId);

    // Update IDs to be unique
    final categoriesWithIds = defaultCategories.map((cat) {
      return cat.copyWith(id: 'category_${_nextId++}');
    }).toList();

    _categories.addAll(categoriesWithIds);
    return categoriesWithIds;
  }

  /// Clears all mock data (for testing)
  void clear() {
    _categories.clear();
    _nextId = 1;
    _initializeMockData();
  }

  /// Gets count of categories by type for a user
  int getCategoryCount(String userId, CategoryType type) {
    return _categories.where((cat) => cat.userId == userId && cat.type == type).length;
  }
}
