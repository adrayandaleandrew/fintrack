import 'package:equatable/equatable.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check if user is logged in (on app start)
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

/// Event to login with email and password
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to register a new user
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String? defaultCurrency;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    this.defaultCurrency,
  });

  @override
  List<Object?> get props => [email, password, name, defaultCurrency];
}

/// Event to logout
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Event to send password reset email
class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event to update user profile
class UpdateProfileRequested extends AuthEvent {
  final String userId;
  final String? name;
  final String? profilePicture;
  final String? defaultCurrency;

  const UpdateProfileRequested({
    required this.userId,
    this.name,
    this.profilePicture,
    this.defaultCurrency,
  });

  @override
  List<Object?> get props => [userId, name, profilePicture, defaultCurrency];
}
