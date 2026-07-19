import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;

  AuthRepositoryImpl({required AuthDatasource datasource})
      : _datasource = datasource;

  @override
  Stream<UserEntity?> watchCurrentUser() {
    return _datasource.watchAuthState().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }

      UserModel? userModel = await _datasource.getUserDocument(firebaseUser.uid);
      if (userModel == null) {
        return null;
      }

      return userModel.toEntity();
    });
  }

  @override
  UserEntity? getCurrentUser() {
    firebase_auth.User? firebaseUser = _datasource.currentFirebaseUser;
    if (firebaseUser == null) {
      return null;
    }

    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? '',
      role: 'customer',
      createdAt: DateTime.now(),
    );
  }

  @override
  FutureResult<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential credential = await _datasource.signInWithEmail(
        email,
        password,
      );

      String userId = credential.user!.uid;
      UserModel? userModel = await _datasource.getUserDocument(userId);

      if (userModel == null) {
        return Left(Failure.notFound('User profile not found. Please contact support.'));
      }

      return Right(userModel.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = _mapFirebaseAuthError(e.code);
      return Left(Failure.auth(message, code: e.code, exception: e));
    } catch (e) {
      return Left(Failure.unexpected('Sign in failed. Please try again.', exception: e as Exception));
    }
  }

  @override
  FutureResult<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      firebase_auth.UserCredential credential = await _datasource.signUpWithEmail(
        email,
        password,
      );

      String userId = credential.user!.uid;

      UserModel newUser = UserModel(
        id: userId,
        email: email,
        name: name,
        phone: phone,
        role: 'customer',
        createdAt: DateTime.now(),
      );

      await _datasource.createUserDocument(newUser);

      return Right(newUser.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = _mapFirebaseAuthError(e.code);
      return Left(Failure.auth(message, code: e.code, exception: e));
    } catch (e) {
      return Left(Failure.unexpected('Sign up failed. Please try again.', exception: e as Exception));
    }
  }

  @override
  FutureResult<void> setUserRole({
    required String userId,
    required String role,
  }) async {
    try {
      await _datasource.updateUserRole(userId, role);
      return const Right(null);
    } catch (e) {
      return Left(Failure.server('Failed to update role.', e as Exception));
    }
  }

  @override
  FutureResult<void> signOut() async {
    try {
      await _datasource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(Failure.unexpected('Sign out failed.', exception: e as Exception));
    }
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
