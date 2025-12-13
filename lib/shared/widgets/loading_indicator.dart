import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../app/theme/colors.dart';

/// Loading indicator widget
///
/// Provides different loading states: spinner, skeleton, and overlay.
class LoadingIndicator extends StatelessWidget {
  /// Size of the loading indicator
  final double size;

  /// Color of the loading indicator
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
  });

  /// Small loading indicator
  const LoadingIndicator.small({
    super.key,
    this.color,
  }) : size = 24;

  /// Medium loading indicator (default)
  const LoadingIndicator.medium({
    super.key,
    this.color,
  }) : size = 40;

  /// Large loading indicator
  const LoadingIndicator.large({
    super.key,
    this.color,
  }) : size = 60;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// Loading overlay widget
///
/// Displays a semi-transparent overlay with loading indicator.
/// Use this to prevent user interaction while loading.
class LoadingOverlay extends StatelessWidget {
  /// Whether to show the overlay
  final bool isLoading;

  /// Child widget to display behind the overlay
  final Widget child;

  /// Loading message
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LoadingIndicator(color: Colors.white),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Skeleton loading widget
///
/// Displays a shimmer effect for loading placeholders.
/// Use this for better UX when loading list items or cards.
class SkeletonLoader extends StatelessWidget {
  /// Width of the skeleton
  final double? width;

  /// Height of the skeleton
  final double height;

  /// Border radius
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius = 4,
  });

  /// Skeleton for a single line of text
  const SkeletonLoader.text({
    super.key,
    this.width,
  })  : height = 16,
        borderRadius = 4;

  /// Skeleton for a title
  const SkeletonLoader.title({
    super.key,
    this.width,
  })  : height = 24,
        borderRadius = 4;

  /// Skeleton for a circle (avatar)
  const SkeletonLoader.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = 999;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? AppColors.shimmerBaseDark
          : AppColors.shimmerBaseLight,
      highlightColor: isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlightLight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Skeleton card loader
///
/// Pre-built skeleton for card-style content.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonLoader.circle(size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonLoader.title(width: 150),
                      SizedBox(height: 8),
                      SkeletonLoader.text(width: 100),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SkeletonLoader.text(width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonLoader.text(width: 200),
          ],
        ),
      ),
    );
  }
}

/// Skeleton list loader
///
/// Pre-built skeleton for list items.
class SkeletonList extends StatelessWidget {
  /// Number of skeleton items to display
  final int itemCount;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}
