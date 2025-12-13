import 'package:flutter/material.dart';
import 'colors.dart';

/// Application text styles.
///
/// Contains all typography styles used throughout the app for consistency.
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // ==================== Display Styles (Extra Large) ====================

  /// Display large - Used for hero text and large headlines
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayLargeDark = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ==================== Headline Styles (Large) ====================

  /// Headline large - Used for page titles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static const TextStyle headlineLargeDark = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryDark,
    letterSpacing: -0.25,
    height: 1.3,
  );

  /// Headline medium - Used for section headers
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle headlineMediumDark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryDark,
    letterSpacing: 0,
    height: 1.3,
  );

  /// Headline small - Used for card titles
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle headlineSmallDark = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryDark,
    letterSpacing: 0,
    height: 1.4,
  );

  // ==================== Title Styles (Medium) ====================

  /// Title large - Used for emphasized text
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static const TextStyle titleLargeDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryDark,
    letterSpacing: 0.15,
    height: 1.4,
  );

  /// Title medium - Used for list item titles
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle titleMediumDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryDark,
    letterSpacing: 0.15,
    height: 1.5,
  );

  /// Title small - Used for subtitles
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle titleSmallDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryDark,
    letterSpacing: 0.1,
    height: 1.5,
  );

  // ==================== Body Styles (Regular) ====================

  /// Body large - Used for main content
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle bodyLargeDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryDark,
    letterSpacing: 0.5,
    height: 1.5,
  );

  /// Body medium - Used for secondary content
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.25,
    height: 1.5,
  );

  static const TextStyle bodyMediumDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryDark,
    letterSpacing: 0.25,
    height: 1.5,
  );

  /// Body small - Used for helper text
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.4,
    height: 1.5,
  );

  static const TextStyle bodySmallDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryDark,
    letterSpacing: 0.4,
    height: 1.5,
  );

  // ==================== Label Styles (Small) ====================

  /// Label large - Used for buttons and tabs
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle labelLargeDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryDark,
    letterSpacing: 0.1,
    height: 1.4,
  );

  /// Label medium - Used for form labels
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static const TextStyle labelMediumDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryDark,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// Label small - Used for captions
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static const TextStyle labelSmallDark = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryDark,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // ==================== Specialized Styles ====================

  /// Amount display - Used for currency amounts (large)
  static const TextStyle amountLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle amountLargeDark = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
    color: AppColors.textPrimaryDark,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Amount display - Used for currency amounts (medium)
  static const TextStyle amountMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'monospace',
    color: AppColors.textPrimaryLight,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle amountMediumDark = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'monospace',
    color: AppColors.textPrimaryDark,
    letterSpacing: 0,
    height: 1.3,
  );

  /// Amount display - Used for currency amounts (small)
  static const TextStyle amountSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'monospace',
    color: AppColors.textPrimaryLight,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle amountSmallDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'monospace',
    color: AppColors.textPrimaryDark,
    letterSpacing: 0,
    height: 1.4,
  );

  /// Button text style
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
    height: 1.4,
  );

  /// Overline text style (all caps, used for categories/tags)
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
    letterSpacing: 1.5,
    height: 1.4,
  );

  static const TextStyle overlineDark = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryDark,
    letterSpacing: 1.5,
    height: 1.4,
  );

  /// Error text style
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    letterSpacing: 0.4,
    height: 1.4,
  );

  /// Success text style
  static const TextStyle success = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.success,
    letterSpacing: 0.4,
    height: 1.4,
  );

  /// Link text style
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    letterSpacing: 0.25,
    height: 1.4,
  );

  static const TextStyle linkDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryLight,
    decoration: TextDecoration.underline,
    letterSpacing: 0.25,
    height: 1.4,
  );

  // ==================== Helper Methods ====================

  /// Applies income color to a text style
  static TextStyle withIncomeColor(TextStyle baseStyle) {
    return baseStyle.copyWith(color: AppColors.income);
  }

  /// Applies expense color to a text style
  static TextStyle withExpenseColor(TextStyle baseStyle) {
    return baseStyle.copyWith(color: AppColors.expense);
  }

  /// Applies transfer color to a text style
  static TextStyle withTransferColor(TextStyle baseStyle) {
    return baseStyle.copyWith(color: AppColors.transfer);
  }

  /// Applies custom color to a text style
  static TextStyle withColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color);
  }

  /// Makes text bold
  static TextStyle toBold(TextStyle baseStyle) {
    return baseStyle.copyWith(fontWeight: FontWeight.bold);
  }

  /// Makes text italic
  static TextStyle toItalic(TextStyle baseStyle) {
    return baseStyle.copyWith(fontStyle: FontStyle.italic);
  }
}
