import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state (checking auth status, logging in, registering, etc.)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated
class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Login success
class LoginSuccess extends AuthState {
  final User user;

  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Register success
class RegisterSuccess extends AuthState {
  final User user;

  const RegisterSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Logout success
class LogoutSuccess extends AuthState {
  const LogoutSuccess();
}

/// Password reset email sent
class PasswordResetEmailSent extends AuthState {
  const PasswordResetEmailSent();
}

/// Profile updated
class ProfileUpdated extends AuthState {
  final User user;

  const ProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
