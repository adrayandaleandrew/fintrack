import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/account.dart';

part 'account_model.g.dart';

/// Account model
///
/// Data layer representation of Account entity.
/// Extends the domain entity and adds JSON serialization.
@JsonSerializable()
class AccountModel extends Account {
  const AccountModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.type,
    required super.balance,
    required super.currency,
    required super.icon,
    required super.color,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.notes,
    super.creditLimit,
    super.interestRate,
  });

  /// Creates an AccountModel from an Account entity
  factory AccountModel.fromEntity(Account account) {
    return AccountModel(
      id: account.id,
      userId: account.userId,
      name: account.name,
      type: account.type,
      balance: account.balance,
      currency: account.currency,
      icon: account.icon,
      color: account.color,
      isActive: account.isActive,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
      notes: account.notes,
      creditLimit: account.creditLimit,
      interestRate: account.interestRate,
    );
  }

  /// Creates an AccountModel from JSON
  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  /// Converts this model to JSON
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);

  /// Creates a copy of this model with updated fields
  @override
  AccountModel copyWith({
    String? id,
    String? userId,
    String? name,
    AccountType? type,
    double? balance,
    String? currency,
    String? icon,
    String? color,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    double? creditLimit,
    double? interestRate,
  }) {
    return AccountModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      creditLimit: creditLimit ?? this.creditLimit,
      interestRate: interestRate ?? this.interestRate,
    );
  }
}
