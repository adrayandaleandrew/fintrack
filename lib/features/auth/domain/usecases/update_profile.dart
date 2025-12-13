import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Update profile use case
///
/// Updates the current user's profile information.
/// This is a single-responsibility class that handles only profile update logic.
class UpdateProfile {
  final AuthRepository repository;

  const UpdateProfile({required this.repository});

  /// Executes the update profile use case
  ///
  /// Returns [Right(User)] on successful update with updated user data
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      userId: params.userId,
      name: params.name,
      profilePicture: params.profilePicture,
      defaultCurrency: params.defaultCurrency,
    );
  }
}

/// Parameters for UpdateProfile use case
class UpdateProfileParams extends Equatable {
  final String userId;
  final String? name;
  final String? profilePicture;
  final String? defaultCurrency;

  const UpdateProfileParams({
    required this.userId,
    this.name,
    this.profilePicture,
    this.defaultCurrency,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        profilePicture,
        defaultCurrency,
      ];
}
