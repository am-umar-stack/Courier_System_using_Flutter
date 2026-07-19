import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/delivery/presentation/screens/booking_screen.dart';
import '../../features/delivery/presentation/screens/delivery_detail_screen.dart';
import '../../features/delivery/presentation/screens/delivery_history_screen.dart';
import '../../features/home/presentation/screens/home_shell_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/rider/presentation/screens/rider_active_deliveries_screen.dart';
import '../../features/rider/presentation/screens/rider_dashboard_screen.dart';
import '../../features/rider/presentation/screens/rider_delivery_screen.dart';
import '../../features/rider/presentation/screens/rider_earnings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/tracking/presentation/screens/tracking_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String roleSelection = '/role-selection';

  static const String customerHome = '/customer';
  static const String booking = '/booking';
  static const String deliveries = '/deliveries';
  static const String deliveryDetail = '/delivery/:id';
  static const String tracking = '/tracking/:id';
  static const String customerProfile = '/profile';

  static const String riderHome = '/rider';
  static const String riderDashboard = '/rider/dashboard';
  static const String riderActive = '/rider/active';
  static const String riderEarnings = '/rider/earnings';
  static const String riderProfile = '/rider/profile';
  static const String riderDelivery = '/rider/delivery/:id';
}

const Set<String> _publicRoutes = {
  AppRoutes.login,
  AppRoutes.signup,
};

final routerProvider = Provider<GoRouter>((ref) {
  AsyncValue<UserEntity?> authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: _AuthStateNotifier(ref),
    redirect: (context, state) {
      UserEntity? currentUser = authState.valueOrNull;
      bool isLoggedIn = currentUser != null;
      String currentPath = state.uri.path;
      bool isPublicRoute = _publicRoutes.contains(currentPath);
      bool isSplash = currentPath == AppRoutes.splash;

      if (isSplash) {
        if (isLoggedIn) {
          return currentUser!.isRider ? AppRoutes.riderDashboard : AppRoutes.booking;
        }
        return null;
      }

      if (!isLoggedIn && !isPublicRoute && !isSplash) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isPublicRoute) {
        return currentUser!.isRider ? AppRoutes.riderDashboard : AppRoutes.booking;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.customerHome,
            builder: (context, state) => const BookingScreen(),
          ),
          GoRoute(
            path: AppRoutes.booking,
            builder: (context, state) => const BookingScreen(),
          ),
          GoRoute(
            path: AppRoutes.deliveries,
            builder: (context, state) => const DeliveryHistoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.deliveryDetail,
            builder: (context, state) {
              String id = state.pathParameters['id']!;
              return DeliveryDetailScreen(deliveryId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.tracking,
            builder: (context, state) {
              String id = state.pathParameters['id']!;
              return TrackingScreen(deliveryId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.customerProfile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.riderHome,
            builder: (context, state) => const RiderDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.riderDashboard,
            builder: (context, state) => const RiderDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.riderActive,
            builder: (context, state) => const RiderActiveDeliveriesScreen(),
          ),
          GoRoute(
            path: AppRoutes.riderEarnings,
            builder: (context, state) => const RiderEarningsScreen(),
          ),
          GoRoute(
            path: AppRoutes.riderProfile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.riderDelivery,
            builder: (context, state) {
              String id = state.pathParameters['id']!;
              return RiderDeliveryScreen(deliveryId: id);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Page Not Found', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(state.uri.toString(), style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).go(AppRoutes.splash),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
});

class _AuthStateNotifier extends ChangeNotifier {
  late final ProviderSubscription _subscription;

  _AuthStateNotifier(Ref ref) {
    _subscription = ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
