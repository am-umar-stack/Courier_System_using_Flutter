import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/app_dimensions.dart';

class AsyncButton extends StatelessWidget {
  final String label;
  final Future<void> Function()? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData? icon;
  final AsyncButtonVariant variant;

  const AsyncButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.variant = AsyncButtonVariant.elevated,
  });

  @override
  Widget build(BuildContext context) {
    bool isInteractive = enabled && !isLoading;

    Widget child;
    if (isLoading) {
      Color spinnerColor;
      if (variant == AsyncButtonVariant.elevated) {
        spinnerColor = Theme.of(context).colorScheme.onPrimary;
      } else {
        spinnerColor = Theme.of(context).colorScheme.primary;
      }

      child = SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
        ),
      );
    } else {
      List<Widget> rowChildren = [];
      if (icon != null) {
        rowChildren.add(Icon(icon, size: AppDimensions.iconSM));
        rowChildren.add(const SizedBox(width: AppDimensions.spacing8));
      }
      rowChildren.add(Text(label));

      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: rowChildren,
      );
    }

    VoidCallback? callback;
    if (isInteractive && onPressed != null) {
      callback = () async {
        await onPressed!();
      };
    }

    switch (variant) {
      case AsyncButtonVariant.elevated:
        return ElevatedButton(onPressed: callback, child: child);
      case AsyncButtonVariant.outlined:
        return OutlinedButton(onPressed: callback, child: child);
      case AsyncButtonVariant.text:
        return TextButton(onPressed: callback, child: child);
    }
  }
}

enum AsyncButtonVariant { elevated, outlined, text }
