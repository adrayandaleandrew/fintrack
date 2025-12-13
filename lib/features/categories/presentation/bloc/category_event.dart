import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';

/// Base class for all category events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all categories for a user
class LoadCategories extends CategoryEvent {
  final String userId;
  final CategoryType? type;

  const LoadCategories({
    required this.userId,
    this.type,
  });

  @override
  List<Object?> get props => [userId, type];
}

/// Event to load a single category by ID
class LoadCategoryById extends CategoryEvent {
  final String categoryId;

  const LoadCategoryById({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

/// Event to create a new custom category
class CreateCategoryRequested extends CategoryEvent {
  final String userId;
  final String name;
  final CategoryType type;
  final String icon;
  final String color;
  final int sortOrder;

  const CreateCategoryRequested({
    required this.userId,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.sortOrder = 0,
  });

  @override
  List<Object?> get props => [userId, name, type, icon, color, sortOrder];
}

/// Event to update an existing category
class UpdateCategoryRequested extends CategoryEvent {
  final String categoryId;
  final String? name;
  final String? icon;
  final String? color;
  final int? sortOrder;

  const UpdateCategoryRequested({
    required this.categoryId,
    this.name,
    this.icon,
    this.color,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [categoryId, name, icon, color, sortOrder];
}

/// Event to delete a category
class DeleteCategoryRequested extends CategoryEvent {
  final String categoryId;

  const DeleteCategoryRequested({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

/// Event to get default categories
class LoadDefaultCategories extends CategoryEvent {
  const LoadDefaultCategories();
}

/// Event to initialize default categories for a new user
class InitializeDefaultCategoriesRequested extends CategoryEvent {
  final String userId;

  const InitializeDefaultCategoriesRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}
