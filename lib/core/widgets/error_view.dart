import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryLabel;

  const ErrorView({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.cloud_off_rounded,
    this.onRetry,
    this.retryLabel = 'Try Again',
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing24),
              decoration: BoxDecoration(
                color: AppColors.errorContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppDimensions.iconXL, color: AppColors.error),
            )
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  duration: AppDimensions.durationSlow,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: AppDimensions.durationNormal),

            const SizedBox(height: AppDimensions.spacing24),

            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),

            if (message != null) ...[
              const SizedBox(height: AppDimensions.spacing12),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
                textAlign: TextAlign.center,
              ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.2, end: 0),
            ],

            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacing32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(retryLabel),
              ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3, end: 0),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateView({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_rounded,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: AppColors.grey400)
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  duration: AppDimensions.durationSlow,
                  curve: Curves.elasticOut,
                )
                .fadeIn(),

            const SizedBox(height: AppDimensions.spacing20),

            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ).animate(delay: 200.ms).fadeIn(),

            if (message != null) ...[
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
                textAlign: TextAlign.center,
              ).animate(delay: 350.ms).fadeIn(),
            ],

            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: AppDimensions.spacing24),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3, end: 0),
            ],
          ],
        ),
      ),
    );
  }
}
