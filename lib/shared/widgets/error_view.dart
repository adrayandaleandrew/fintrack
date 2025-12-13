import 'package:flutter/material.dart';
import 'custom_button.dart';

/// Error view widget
///
/// Displays error messages with optional retry functionality.
/// Use this for displaying errors in a consistent way across the app.
class ErrorView extends StatelessWidget {
  /// Error message to display
  final String message;

  /// Retry callback
  final VoidCallback? onRetry;

  /// Error icon
  final IconData icon;

  /// Error title
  final String? title;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.title,
  });

  /// Network error view
  factory ErrorView.network({
    Key? key,
    VoidCallback? onRetry,
  }) {
    return ErrorView(
      key: key,
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  /// Server error view
  factory ErrorView.server({
    Key? key,
    String? message,
    VoidCallback? onRetry,
  }) {
    return ErrorView(
      key: key,
      title: 'Server Error',
      message: message ?? 'Something went wrong on our end. Please try again later.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }

  /// Not found error view
  factory ErrorView.notFound({
    Key? key,
    String? message,
  }) {
    return ErrorView(
      key: key,
      title: 'Not Found',
      message: message ?? 'The requested resource was not found.',
      icon: Icons.search_off,
    );
  }

  /// Unauthorized error view
  factory ErrorView.unauthorized({
    Key? key,
    VoidCallback? onRetry,
  }) {
    return ErrorView(
      key: key,
      title: 'Unauthorized',
      message: 'Please log in to access this content.',
      icon: Icons.lock_outline,
      onRetry: onRetry,
    );
  }

  /// Generic error view
  factory ErrorView.generic({
    Key? key,
    String? message,
    VoidCallback? onRetry,
  }) {
    return ErrorView(
      key: key,
      title: 'Error',
      message: message ?? 'An unexpected error occurred.',
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 24),
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              CustomButton.primary(
                text: 'Try Again',
                onPressed: onRetry,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Inline error widget
///
/// Displays a compact error message with icon.
/// Use this for form validation or inline errors.
class InlineError extends StatelessWidget {
  /// Error message
  final String message;

  /// Error icon
  final IconData icon;

  const InlineError({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Error snackbar helper
///
/// Shows a snackbar with error message.
class ErrorSnackbar {
  /// Shows an error snackbar
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

/// Success snackbar helper
///
/// Shows a snackbar with success message.
class SuccessSnackbar {
  /// Shows a success snackbar
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
