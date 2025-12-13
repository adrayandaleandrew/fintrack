import 'package:flutter/material.dart';

/// Custom card widget with consistent styling
///
/// Provides a styled card container with optional header and footer.
class CustomCard extends StatelessWidget {
  /// Card child widget
  final Widget child;

  /// Card padding
  final EdgeInsetsGeometry? padding;

  /// Card margin
  final EdgeInsetsGeometry? margin;

  /// On tap callback
  final VoidCallback? onTap;

  /// Card elevation
  final double? elevation;

  /// Card color
  final Color? color;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.elevation,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation,
      color: color,
      margin: margin,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }

    return card;
  }
}

/// Card with header and body
///
/// Pre-styled card with title and optional subtitle.
class HeaderCard extends StatelessWidget {
  /// Card title
  final String title;

  /// Card subtitle
  final String? subtitle;

  /// Card body widget
  final Widget child;

  /// Header trailing widget
  final Widget? trailing;

  /// Card padding
  final EdgeInsetsGeometry? padding;

  /// On tap callback
  final VoidCallback? onTap;

  const HeaderCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.trailing,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Icon card widget
///
/// Card with icon, title, and value.
class IconCard extends StatelessWidget {
  /// Card icon
  final IconData icon;

  /// Icon background color
  final Color? iconColor;

  /// Card title
  final String title;

  /// Card value
  final String value;

  /// On tap callback
  final VoidCallback? onTap;

  const IconCard({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (iconColor ?? Theme.of(context).colorScheme.primary)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Summary card widget
///
/// Card displaying a summary metric with optional trend indicator.
class SummaryCard extends StatelessWidget {
  /// Card title
  final String title;

  /// Card value
  final String value;

  /// Trend percentage (optional)
  final double? trendPercentage;

  /// Card icon
  final IconData? icon;

  /// Card color
  final Color? color;

  /// On tap callback
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.trendPercentage,
    this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: effectiveColor,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (trendPercentage != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  trendPercentage! >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 16,
                  color: trendPercentage! >= 0 ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '${trendPercentage!.abs().toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: trendPercentage! >= 0 ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
