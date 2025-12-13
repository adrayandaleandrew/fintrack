import 'package:equatable/equatable.dart';

/// User entity
///
/// Represents a user in the domain layer.
/// This is a pure Dart class with no dependencies on external packages
/// (except Equatable for value equality).
class User extends Equatable {
  /// Unique identifier
  final String id;

  /// User email address
  final String email;

  /// User full name
  final String name;

  /// Profile picture URL
  final String? profilePicture;

  /// Default currency code (e.g., 'USD', 'EUR')
  final String defaultCurrency;

  /// Account creation timestamp
  final DateTime createdAt;

  /// Last login timestamp
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
    required this.defaultCurrency,
    required this.createdAt,
    this.lastLoginAt,
  });

  /// Creates a copy of this user with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
    String? defaultCurrency,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        profilePicture,
        defaultCurrency,
        createdAt,
        lastLoginAt,
      ];

  @override
  bool get stringify => true;
}
