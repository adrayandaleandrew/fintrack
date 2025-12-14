import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/budget.dart';

part 'budget_model.g.dart';

/// Budget model for JSON serialization
///
/// Extends Budget entity with JSON serialization capabilities.
@JsonSerializable(explicitToJson: true)
class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.userId,
    required super.categoryId,
    required super.amount,
    required super.currency,
    required super.period,
    required super.startDate,
    super.endDate,
    super.alertThreshold,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create BudgetModel from Budget entity
  factory BudgetModel.fromEntity(Budget budget) {
    return BudgetModel(
      id: budget.id,
      userId: budget.userId,
      categoryId: budget.categoryId,
      amount: budget.amount,
      currency: budget.currency,
      period: budget.period,
      startDate: budget.startDate,
      endDate: budget.endDate,
      alertThreshold: budget.alertThreshold,
      isActive: budget.isActive,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }

  /// Create BudgetModel from JSON
  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  /// Convert BudgetModel to JSON
  Map<String, dynamic> toJson() => _$BudgetModelToJson(this);

  /// Convert to Budget entity
  Budget toEntity() {
    return Budget(
      id: id,
      userId: userId,
      categoryId: categoryId,
      amount: amount,
      currency: currency,
      period: period,
      startDate: startDate,
      endDate: endDate,
      alertThreshold: alertThreshold,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a copy with updated fields
  @override
  BudgetModel copyWith({
    String? id,
    String? userId,
    String? categoryId,
    double? amount,
    String? currency,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    double? alertThreshold,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
