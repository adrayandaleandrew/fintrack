import 'package:flutter/material.dart';

/// Custom button widget with consistent styling
///
/// Provides primary, secondary, text, and outlined button variants
/// with loading state support.
class CustomButton extends StatelessWidget {
  /// Button text
  final String text;

  /// Button pressed callback
  final VoidCallback? onPressed;

  /// Button type
  final ButtonType type;

  /// Button size
  final ButtonSize size;

  /// Loading state
  final bool isLoading;

  /// Full width button
  final bool fullWidth;

  /// Icon to display before text
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
    this.icon,
  });

  /// Primary button
  const CustomButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
    this.icon,
  }) : type = ButtonType.primary;

  /// Secondary button
  const CustomButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
    this.icon,
  }) : type = ButtonType.secondary;

  /// Text button
  const CustomButton.text({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
    this.icon,
  }) : type = ButtonType.text;

  /// Outlined button
  const CustomButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
    this.icon,
  }) : type = ButtonType.outlined;

  @override
  Widget build(BuildContext context) {
    final buttonChild = _buildButtonContent();
    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button;
    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            padding: _getPadding(),
            minimumSize: fullWidth ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.secondary:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            padding: _getPadding(),
            minimumSize: fullWidth ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            padding: _getPadding(),
            minimumSize: fullWidth ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            padding: _getPadding(),
            minimumSize: fullWidth ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;
    }

    return button;
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

/// Button type variants
enum ButtonType {
  primary,
  secondary,
  text,
  outlined,
}

/// Button size variants
enum ButtonSize {
  small,
  medium,
  large,
}
