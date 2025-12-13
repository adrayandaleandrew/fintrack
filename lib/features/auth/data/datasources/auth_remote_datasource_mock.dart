import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Mock implementation of AuthRemoteDataSource
///
/// Simulates API calls with in-memory storage.
/// Use this during development before real API is available.
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  // In-memory storage for registered users
  final List<UserModel> _users = [];

  // Current session user ID
  String? _currentUserId;

  AuthRemoteDataSourceMock() {
    _initializeMockData();
  }

  /// Initializes mock data with a test user
  void _initializeMockData() {
    final testUser = UserModel(
      id: 'user_1',
      email: 'test@example.com',
      name: 'Test User',
      defaultCurrency: AppConstants.defaultCurrency,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
    );

    _users.add(testUser);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Find user by email
    final userIndex = _users.indexWhere((user) => user.email == email);

    if (userIndex == -1) {
      throw AuthException('Invalid email or password');
    }

    // In a real implementation, we would verify password hash
    // For mock, we just accept any password

    // Update last login time
    final user = _users[userIndex];
    final updatedUser = user.copyWith(
      lastLoginAt: DateTime.now(),
    ) as UserModel;

    _users[userIndex] = updatedUser;
    _currentUserId = user.id;

    return updatedUser;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String? defaultCurrency,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    // Check if email already exists
    final existingUser = _users.any((user) => user.email == email);

    if (existingUser) {
      throw ServerException('Email already registered');
    }

    // Create new user
    final newUser = UserModel(
      id: 'user_${_users.length + 1}',
      email: email,
      name: name,
      defaultCurrency: defaultCurrency ?? AppConstants.defaultCurrency,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    _users.add(newUser);
    _currentUserId = newUser.id;

    return newUser;
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if email exists
    final userExists = _users.any((user) => user.email == email);

    if (!userExists) {
      throw NotFoundException('User not found with email: $email');
    }

    // In a real implementation, this would send an email
    // For mock, we just simulate success
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? profilePicture,
    String? defaultCurrency,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Find user by ID
    final userIndex = _users.indexWhere((user) => user.id == userId);

    if (userIndex == -1) {
      throw NotFoundException('User not found');
    }

    // Update user
    final user = _users[userIndex];
    final updatedUser = user.copyWith(
      name: name ?? user.name,
      profilePicture: profilePicture ?? user.profilePicture,
      defaultCurrency: defaultCurrency ?? user.defaultCurrency,
    ) as UserModel;

    _users[userIndex] = updatedUser;

    return updatedUser;
  }

  /// Clears all mock data (for testing)
  void clear() {
    _users.clear();
    _currentUserId = null;
    _initializeMockData();
  }
}
