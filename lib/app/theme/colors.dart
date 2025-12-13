import 'package:flutter/material.dart';

/// Application color palette.
///
/// Contains all colors used throughout the app for consistent theming.
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ==================== Primary Colors ====================

  /// Main brand color (Blue)
  static const Color primary = Color(0xFF2196F3);

  /// Darker shade of primary color
  static const Color primaryDark = Color(0xFF1976D2);

  /// Lighter shade of primary color
  static const Color primaryLight = Color(0xFF64B5F6);

  // ==================== Accent Colors ====================

  /// Accent color for highlights and CTAs
  static const Color accent = Color(0xFFFF9800);

  /// Darker shade of accent color
  static const Color accentDark = Color(0xFFF57C00);

  /// Lighter shade of accent color
  static const Color accentLight = Color(0xFFFFB74D);

  // ==================== Semantic Colors ====================

  /// Success state color (Green)
  static const Color success = Color(0xFF4CAF50);

  /// Warning state color (Amber)
  static const Color warning = Color(0xFFFFC107);

  /// Error state color (Red)
  static const Color error = Color(0xFFF44336);

  /// Info state color (Blue)
  static const Color info = Color(0xFF2196F3);

  // ==================== Transaction Type Colors ====================

  /// Income transactions color (Green)
  static const Color income = Color(0xFF4CAF50);

  /// Expense transactions color (Red)
  static const Color expense = Color(0xFFF44336);

  /// Transfer transactions color (Blue)
  static const Color transfer = Color(0xFF2196F3);

  // ==================== Budget Alert Colors ====================

  /// Budget status - under threshold (Green)
  static const Color budgetSafe = Color(0xFF4CAF50);

  /// Budget status - approaching threshold (Amber)
  static const Color budgetWarning = Color(0xFFFFC107);

  /// Budget status - exceeded threshold (Red)
  static const Color budgetDanger = Color(0xFFF44336);

  // ==================== Neutral Colors (Light Theme) ====================

  /// Background color for light theme
  static const Color backgroundLight = Color(0xFFF5F5F5);

  /// Surface color for cards and elevated elements (light theme)
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Primary text color (light theme)
  static const Color textPrimaryLight = Color(0xFF212121);

  /// Secondary text color (light theme)
  static const Color textSecondaryLight = Color(0xFF757575);

  /// Disabled text color (light theme)
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  /// Divider color (light theme)
  static const Color dividerLight = Color(0xFFE0E0E0);

  // ==================== Neutral Colors (Dark Theme) ====================

  /// Background color for dark theme
  static const Color backgroundDark = Color(0xFF121212);

  /// Surface color for cards and elevated elements (dark theme)
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Primary text color (dark theme)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);

  /// Secondary text color (dark theme)
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  /// Disabled text color (dark theme)
  static const Color textDisabledDark = Color(0xFF757575);

  /// Divider color (dark theme)
  static const Color dividerDark = Color(0xFF303030);

  // ==================== Chart Colors ====================

  /// Chart colors for data visualization
  static const List<Color> chartColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFFF44336), // Red
    Color(0xFF4CAF50), // Green
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFFFFEB3B), // Yellow
    Color(0xFF00BCD4), // Cyan
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF673AB7), // Deep Purple
    Color(0xFF8BC34A), // Light Green
    Color(0xFFE91E63), // Pink
    Color(0xFF009688), // Teal
  ];

  // ==================== Gradient Colors ====================

  /// Primary gradient (Blue gradient)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Income gradient (Green gradient)
  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Expense gradient (Red gradient)
  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFF44336), Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== Shadow Colors ====================

  /// Light shadow for elevated components (light theme)
  static const Color shadowLight = Color(0x1F000000);

  /// Shadow for elevated components (dark theme)
  static const Color shadowDark = Color(0x3F000000);

  // ==================== Shimmer Colors (Loading skeleton) ====================

  /// Base color for shimmer effect (light theme)
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);

  /// Highlight color for shimmer effect (light theme)
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);

  /// Base color for shimmer effect (dark theme)
  static const Color shimmerBaseDark = Color(0xFF2C2C2C);

  /// Highlight color for shimmer effect (dark theme)
  static const Color shimmerHighlightDark = Color(0xFF3A3A3A);

  // ==================== Helper Methods ====================

  /// Gets a chart color by index, cycling through available colors
  static Color getChartColor(int index) {
    return chartColors[index % chartColors.length];
  }

  /// Converts hex color string to Color object
  ///
  /// Example: hexToColor('#FF5722') -> Color(0xFFFF5722)
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add alpha if not present
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Converts Color object to hex string
  ///
  /// Example: colorToHex(Color(0xFFFF5722)) -> '#FF5722'
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  /// Returns appropriate text color for a given background color
  ///
  /// Uses luminance to determine if white or black text is more readable
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimaryLight : textPrimaryDark;
  }
}
