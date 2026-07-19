import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> watchCurrentUser();

  UserEntity? getCurrentUser();

  FutureResult<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  FutureResult<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  FutureResult<void> setUserRole({
    required String userId,
    required String role,
  });

  FutureResult<void> signOut();
}
