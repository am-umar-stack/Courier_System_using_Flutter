import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _selectRole(WidgetRef ref, BuildContext context, String role) async {
    await ref.read(authControllerProvider.notifier).setUserRole(role);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthState authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is AuthError) {
        context.showErrorSnackBar(next.message);
      } else if (next is AuthAuthenticated) {
        String destination = next.user.isRider
            ? AppRoutes.riderDashboard
            : AppRoutes.booking;
        context.go(destination);
      }
    });

    bool isLoading = authState is AuthLoading;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacing24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: AppDimensions.spacing48),
                  Text('How will you use SwiftDrop?', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'Choose your role to get started',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing48),
                  _RoleCard(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Send a Package',
                    description: 'Book deliveries and track them in real-time',
                    color: AppColors.primary,
                    isLoading: isLoading,
                    onTap: () => _selectRole(ref, context, AppConstants.roleCustomer),
                  ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.1, end: 0),
                  const SizedBox(height: AppDimensions.spacing20),
                  _RoleCard(
                    icon: Icons.delivery_dining_outlined,
                    title: 'Become a Rider',
                    description: 'Earn money by delivering packages',
                    color: AppColors.secondary,
                    isLoading: isLoading,
                    onTap: () => _selectRole(ref, context, AppConstants.roleRider),
                  ).animate(delay: 400.ms).fadeIn().slideX(begin: 0.1, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: AppDimensions.spacing20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
