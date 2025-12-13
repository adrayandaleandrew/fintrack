import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

/// Data model for Category with JSON serialization
///
/// Extends the domain Category entity and adds JSON serialization capabilities.
@JsonSerializable()
class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.type,
    required super.icon,
    required super.color,
    super.sortOrder,
    super.isDefault,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Creates a CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Converts this CategoryModel to JSON
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Converts domain Category to CategoryModel
  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      userId: category.userId,
      name: category.name,
      type: category.type,
      icon: category.icon,
      color: category.color,
      sortOrder: category.sortOrder,
      isDefault: category.isDefault,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  /// Creates a copy with updated fields
  @override
  CategoryModel copyWith({
    String? id,
    String? userId,
    String? name,
    CategoryType? type,
    String? icon,
    String? color,
    int? sortOrder,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
