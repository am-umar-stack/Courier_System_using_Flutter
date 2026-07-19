import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/theme/app_colors.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const ShimmerLoading({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      highlightColor: isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

class DeliveryCardShimmer extends StatelessWidget {
  const DeliveryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color placeholderColor = isDark ? AppColors.surfaceVariantDark : AppColors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ShimmerLoading(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: placeholderColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Placeholder(width: 60, height: 20, color: placeholderColor),
                  const Spacer(),
                  _Placeholder(width: 80, height: 20, color: placeholderColor),
                ],
              ),
              const SizedBox(height: 16),
              _AddressLine(color: placeholderColor),
              const SizedBox(height: 12),
              _AddressLine(color: placeholderColor),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Placeholder(width: 100, height: 18, color: placeholderColor),
                  _Placeholder(width: 60, height: 18, color: placeholderColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _Placeholder({required this.width, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

class _AddressLine extends StatelessWidget {
  final Color color;

  const _AddressLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Placeholder(width: double.infinity, height: 14, color: color),
        ),
      ],
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;

  const ShimmerList({super.key, this.itemCount = 5, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
}
