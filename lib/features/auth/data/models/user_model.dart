import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// User model
///
/// Data layer representation of User entity.
/// Extends the domain entity and adds JSON serialization.
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.profilePicture,
    required super.defaultCurrency,
    required super.createdAt,
    super.lastLoginAt,
  });

  /// Creates a UserModel from a User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      profilePicture: user.profilePicture,
      defaultCurrency: user.defaultCurrency,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
    );
  }

  /// Creates a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this model to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Creates a copy of this model with updated fields
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
    String? defaultCurrency,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
