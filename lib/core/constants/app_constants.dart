class AppConstants {
  AppConstants._();

  static const String appName = 'SwiftDrop';
  static const String appTagline = 'Deliver anything, anywhere.';
  static const String appVersion = '1.0.0';

  static const String usersCollection = 'users';
  static const String deliveriesCollection = 'deliveries';
  static const String ridersCollection = 'riders';
  static const String notificationsCollection = 'notifications';

  static const String roleCustomer = 'customer';
  static const String roleRider = 'rider';

  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusPickedUp = 'picked_up';
  static const String statusInTransit = 'in_transit';
  static const String statusDelivered = 'delivered';
  static const String statusCancelled = 'cancelled';

  static const double baseFare = 50.0;
  static const double perKmRate = 15.0;
  static const double freeKmIncluded = 2.0;
  static const double surgeMultiplier = 1.0;

  static const int defaultPageSize = 20;

  static const String prefOnboardingComplete = 'onboarding_complete';
  static const String prefThemeMode = 'theme_mode';
  static const String prefSelectedRole = 'selected_role';
}
