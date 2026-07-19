import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  return AuthDatasource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  AuthDatasource datasource = ref.watch(authDatasourceProvider);
  return AuthRepositoryImpl(datasource: datasource);
});

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  AuthRepository repository = ref.watch(authRepositoryProvider);
  return repository.watchCurrentUser();
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  AsyncValue<UserEntity?> authState = ref.watch(authStateProvider);
  return authState.valueOrNull;
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController({
    required AuthRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(const AuthInitial()) {
    _initializeAuthState();
  }

  void _initializeAuthState() {
    _ref.listen<AsyncValue<UserEntity?>>(authStateProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            state = AuthAuthenticated(user: user);
          } else {
            state = const AuthUnauthenticated();
          }
        },
        loading: () {
          state = const AuthLoading();
        },
        error: (error, stack) {
          state = AuthError(message: error.toString());
        },
      );
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _repository.signInWithEmail(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        state = AuthError(message: failure.message);
      },
      (user) {
        state = AuthAuthenticated(user: user);
      },
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    state = const AuthLoading();

    final result = await _repository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    result.fold(
      (failure) {
        state = AuthError(message: failure.message);
      },
      (user) {
        state = AuthAuthenticated(user: user);
      },
    );
  }

  Future<void> setUserRole(String role) async {
    UserEntity? currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) {
      state = const AuthError(message: 'No authenticated user.');
      return;
    }

    state = const AuthLoading();

    final result = await _repository.setUserRole(
      userId: currentUser.id,
      role: role,
    );

    result.fold(
      (failure) {
        state = AuthError(message: failure.message);
      },
      (_) {
        UserEntity updatedUser = UserEntity(
          id: currentUser.id,
          email: currentUser.email,
          name: currentUser.name,
          phone: currentUser.phone,
          role: role,
          createdAt: currentUser.createdAt,
        );
        state = AuthAuthenticated(user: updatedUser);
      },
    );
  }

  Future<void> signOut() async {
    state = const AuthLoading();

    final result = await _repository.signOut();

    result.fold(
      (failure) {
        state = AuthError(message: failure.message);
      },
      (_) {
        state = const AuthUnauthenticated();
      },
    );
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  AuthRepository repository = ref.watch(authRepositoryProvider);
  return AuthController(repository: repository, ref: ref);
});
