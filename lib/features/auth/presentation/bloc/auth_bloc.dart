import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/is_user_logged_in.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/send_password_reset_email.dart';
import '../../domain/usecases/update_profile.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
///
/// Handles all authentication-related events and states.
/// Coordinates use cases and transforms domain results into UI states.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final Logout logout;
  final GetCurrentUser getCurrentUser;
  final IsUserLoggedIn isUserLoggedIn;
  final SendPasswordResetEmail sendPasswordResetEmail;
  final UpdateProfile updateProfile;

  AuthBloc({
    required this.login,
    required this.register,
    required this.logout,
    required this.getCurrentUser,
    required this.isUserLoggedIn,
    required this.sendPasswordResetEmail,
    required this.updateProfile,
  }) : super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  /// Checks if user is already logged in (on app start)
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await isUserLoggedIn();

    await result.fold(
      (failure) async {
        emit(const Unauthenticated());
      },
      (loggedIn) async {
        if (loggedIn) {
          final userResult = await getCurrentUser();
          userResult.fold(
            (failure) => emit(const Unauthenticated()),
            (user) => emit(Authenticated(user: user)),
          );
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  /// Handles login request
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await login(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(LoginSuccess(user: user)),
    );
  }

  /// Handles registration request
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await register(
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
        defaultCurrency: event.defaultCurrency,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(RegisterSuccess(user: user)),
    );
  }

  /// Handles logout request
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logout();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const LogoutSuccess()),
    );
  }

  /// Handles password reset request
  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await sendPasswordResetEmail(
      SendPasswordResetEmailParams(email: event.email),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const PasswordResetEmailSent()),
    );
  }

  /// Handles profile update request
  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await updateProfile(
      UpdateProfileParams(
        userId: event.userId,
        name: event.name,
        profilePicture: event.profilePicture,
        defaultCurrency: event.defaultCurrency,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(ProfileUpdated(user: user)),
    );
  }
}
