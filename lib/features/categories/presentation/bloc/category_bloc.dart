import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_category_by_id.dart';
import '../../domain/usecases/get_default_categories.dart';
import '../../domain/usecases/initialize_default_categories.dart';
import '../../domain/usecases/update_category.dart';
import 'category_event.dart';
import 'category_state.dart';

/// BLoC for managing category-related business logic and state
///
/// Handles all category operations including CRUD and default category initialization.
/// Coordinates between UI events and domain use cases.
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  final GetCategoryById getCategoryById;
  final CreateCategory createCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;
  final GetDefaultCategories getDefaultCategories;
  final InitializeDefaultCategories initializeDefaultCategories;

  CategoryBloc({
    required this.getCategories,
    required this.getCategoryById,
    required this.createCategory,
    required this.updateCategory,
    required this.deleteCategory,
    required this.getDefaultCategories,
    required this.initializeDefaultCategories,
  }) : super(const CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadCategoryById>(_onLoadCategoryById);
    on<CreateCategoryRequested>(_onCreateCategoryRequested);
    on<UpdateCategoryRequested>(_onUpdateCategoryRequested);
    on<DeleteCategoryRequested>(_onDeleteCategoryRequested);
    on<LoadDefaultCategories>(_onLoadDefaultCategories);
    on<InitializeDefaultCategoriesRequested>(
      _onInitializeDefaultCategoriesRequested,
    );
  }

  /// Handles loading all categories for a user
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());

    final result = await getCategories(
      GetCategoriesParams(
        userId: event.userId,
        type: event.type,
      ),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categories) => emit(CategoriesLoaded(
        categories: categories,
        filterType: event.type,
      )),
    );
  }

  /// Handles loading a single category by ID
  Future<void> _onLoadCategoryById(
    LoadCategoryById event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());

    final result = await getCategoryById(
      GetCategoryByIdParams(categoryId: event.categoryId),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (category) => emit(CategoryLoaded(category: category)),
    );
  }

  /// Handles creating a new category
  Future<void> _onCreateCategoryRequested(
    CreateCategoryRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());

    final result = await createCategory(
      CreateCategoryParams(
        userId: event.userId,
        name: event.name,
        type: event.type,
        icon: event.icon,
        color: event.color,
        sortOrder: event.sortOrder,
      ),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (category) => emit(CategoryActionSuccess(
        message: 'Category "${category.name}" created successfully',
        category: category,
      )),
    );
  }

  /// Handles updating an existing category
  Future<void> _onUpdateCategoryRequested(
    UpdateCategoryRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());

    final result = await updateCategory(
      UpdateCategoryParams(
        categoryId: event.categoryId,
        name: event.name,
        icon: event.icon,
        color: event.color,
        sortOrder: event.sortOrder,
      ),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (category) => emit(CategoryActionSuccess(
        message: 'Category "${category.name}" updated successfully',
        category: category,
      )),
    );
  }

  /// Handles deleting a category
  Future<void> _onDeleteCategoryRequested(
    DeleteCategoryRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());

    final result = await deleteCategory(
      DeleteCategoryParams(categoryId: event.categoryId),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (_) => emit(const CategoryActionSuccess(
        message: 'Category deleted successfully',
      )),
    );
  }

  /// Handles loading default categories
  Future<void> _onLoadDefaultCategories(
    LoadDefaultCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());

    final result = await getDefaultCategories();

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categories) => emit(DefaultCategoriesLoaded(categories: categories)),
    );
  }

  /// Handles initializing default categories for a new user
  Future<void> _onInitializeDefaultCategoriesRequested(
    InitializeDefaultCategoriesRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());

    final result = await initializeDefaultCategories(
      InitializeDefaultCategoriesParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categories) => emit(CategoryActionSuccess(
        message:
            'Successfully initialized ${categories.length} default categories',
      )),
    );
  }
}
