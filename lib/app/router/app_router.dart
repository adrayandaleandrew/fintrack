import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/categories/presentation/pages/category_list_page.dart';
import '../../features/accounts/presentation/pages/account_list_page.dart';
import '../../features/transactions/presentation/pages/transaction_list_page.dart';
import '../../features/transactions/presentation/pages/transaction_form_page.dart';
import '../../features/transactions/presentation/pages/transaction_detail_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/budgets/presentation/pages/budget_list_page.dart';
import '../../features/budgets/presentation/pages/budget_form_page.dart';
import '../../features/budgets/presentation/pages/budget_detail_page.dart';
import '../../features/budgets/domain/entities/budget.dart';
import '../../features/recurring_transactions/presentation/pages/recurring_transaction_list_page.dart';
import '../../features/recurring_transactions/presentation/pages/recurring_transaction_form_page.dart';
import '../../features/recurring_transactions/domain/entities/recurring_transaction.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/currency/presentation/pages/settings_page.dart';
import 'route_names.dart';
import 'route_paths.dart';

/// Application router configuration
///
/// Configures all routes for the application using go_router.
/// Handles navigation, redirects, and route guards.
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// Helper method to get the current authenticated user ID from context
  /// Returns empty string if user is not authenticated
  static String _getUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    if (authState is Authenticated) {
      return authState.user.id;
    } else if (authState is LoginSuccess) {
      return authState.user.id;
    } else if (authState is RegisterSuccess) {
      return authState.user.id;
    } else if (authState is ProfileUpdated) {
      return authState.user.id;
    }

    // Fallback for unauthenticated users
    return '';
  }

  /// Creates and configures the router
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      debugLogDiagnostics: true,
      routes: [
        // ==================== Splash ====================
        GoRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),

        // ==================== Onboarding ====================
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),

        // ==================== Authentication ====================
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RoutePaths.register,
          name: RouteNames.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: RoutePaths.forgotPassword,
          name: RouteNames.forgotPassword,
          builder: (context, state) => const _PlaceholderPage(
            title: 'Forgot Password',
            description: 'Forgot password page will be implemented in auth feature',
          ),
        ),

        // ==================== Main Navigation ====================
        GoRoute(
          path: RoutePaths.dashboard,
          name: RouteNames.dashboard,
          builder: (context, state) => DashboardPage(
            userId: _getUserId(context),
          ),
        ),

        // ==================== Transactions ====================
        GoRoute(
          path: RoutePaths.transactions,
          name: RouteNames.transactions,
          builder: (context, state) => TransactionListPage(
            userId: _getUserId(context),
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: RouteNames.addTransaction,
              builder: (context, state) => TransactionFormPage(
                userId: _getUserId(context),
              ),
            ),
            GoRoute(
              path: ':id',
              name: RouteNames.transactionDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return TransactionDetailPage(transactionId: id);
              },
            ),
            GoRoute(
              path: ':id/edit',
              name: RouteNames.editTransaction,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return _PlaceholderPage(
                  title: 'Edit Transaction',
                  description: 'Edit transaction $id',
                );
              },
            ),
          ],
        ),

        // ==================== Accounts ====================
        GoRoute(
          path: RoutePaths.accounts,
          name: RouteNames.accounts,
          builder: (context, state) => AccountListPage(
            userId: _getUserId(context),
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: RouteNames.addAccount,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Add Account',
                description: 'Form to add new account',
              ),
            ),
            GoRoute(
              path: ':id',
              name: RouteNames.accountDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return _PlaceholderPage(
                  title: 'Account Detail',
                  description: 'Details for account $id',
                );
              },
            ),
            GoRoute(
              path: ':id/edit',
              name: RouteNames.editAccount,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return _PlaceholderPage(
                  title: 'Edit Account',
                  description: 'Edit account $id',
                );
              },
            ),
          ],
        ),

        // ==================== Categories ====================
        GoRoute(
          path: RoutePaths.categories,
          name: RouteNames.categories,
          builder: (context, state) => CategoryListPage(
            userId: _getUserId(context),
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: RouteNames.addCategory,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Add Category',
                description: 'Form to add new category',
              ),
            ),
            GoRoute(
              path: ':id/edit',
              name: RouteNames.editCategory,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return _PlaceholderPage(
                  title: 'Edit Category',
                  description: 'Edit category $id',
                );
              },
            ),
          ],
        ),

        // ==================== Budgets ====================
        GoRoute(
          path: RoutePaths.budgets,
          name: RouteNames.budgets,
          builder: (context, state) => BudgetListPage(
            userId: _getUserId(context),
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: RouteNames.addBudget,
              builder: (context, state) => const BudgetFormPage(),
            ),
            GoRoute(
              path: ':id',
              name: RouteNames.budgetDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return BudgetDetailPage(
                  budgetId: id,
                  userId: _getUserId(context),
                );
              },
            ),
            GoRoute(
              path: 'edit',
              name: RouteNames.editBudget,
              builder: (context, state) {
                final budget = state.extra as Budget?;
                return BudgetFormPage(
                  budget: budget,
                  userId: _getUserId(context),
                );
              },
            ),
          ],
        ),

        // ==================== Recurring Transactions ====================
        GoRoute(
          path: RoutePaths.recurringTransactions,
          name: RouteNames.recurringTransactions,
          builder: (context, state) => RecurringTransactionListPage(
            userId: _getUserId(context),
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: RouteNames.addRecurringTransaction,
              builder: (context, state) => RecurringTransactionFormPage(
                userId: _getUserId(context),
              ),
            ),
            GoRoute(
              path: ':id',
              name: RouteNames.recurringTransactionDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return _PlaceholderPage(
                  title: 'Recurring Transaction Detail',
                  description: 'Details for recurring transaction $id',
                );
              },
            ),
            GoRoute(
              path: ':id/edit',
              name: RouteNames.editRecurringTransaction,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                final recurringTransaction = state.extra as RecurringTransaction?;
                return RecurringTransactionFormPage(
                  userId: _getUserId(context),
                  recurringTransaction: recurringTransaction,
                );
              },
            ),
          ],
        ),

        // ==================== Reports ====================
        GoRoute(
          path: RoutePaths.reports,
          name: RouteNames.reports,
          builder: (context, state) => ReportsPage(
            userId: _getUserId(context),
          ),
        ),

        // ==================== Settings ====================
        GoRoute(
          path: RoutePaths.settings,
          name: RouteNames.settings,
          builder: (context, state) => SettingsPage(
            userId: _getUserId(context),
          ),
          routes: [
            GoRoute(
              path: 'profile',
              name: RouteNames.profile,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Profile',
                description: 'User profile settings',
              ),
            ),
            GoRoute(
              path: 'currency',
              name: RouteNames.currency,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Currency Settings',
                description: 'Manage currencies and exchange rates',
              ),
            ),
            GoRoute(
              path: 'theme',
              name: RouteNames.theme,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Theme Settings',
                description: 'Light/Dark mode and appearance',
              ),
            ),
            GoRoute(
              path: 'about',
              name: RouteNames.about,
              builder: (context, state) => const _PlaceholderPage(
                title: 'About',
                description: 'App version and information',
              ),
            ),
          ],
        ),
      ],

      // Error handler for unknown routes
      errorBuilder: (context, state) => _ErrorPage(
        error: state.error.toString(),
      ),

      // Redirect logic for authentication
      // TODO: Implement redirect based on auth state
      // redirect: (context, state) {
      //   final isLoggedIn = /* check auth state */;
      //   final isOnLoginPage = state.matchedLocation == RoutePaths.login;
      //
      //   if (!isLoggedIn && !isOnLoginPage) {
      //     return RoutePaths.login;
      //   }
      //
      //   if (isLoggedIn && isOnLoginPage) {
      //     return RoutePaths.dashboard;
      //   }
      //
      //   return null; // No redirect needed
      // },
    );
  }
}

/// Placeholder page for routes not yet implemented
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final String description;

  const _PlaceholderPage({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                'This page will be implemented when building the ${title.toLowerCase()} feature.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error page for 404 and other routing errors
class _ErrorPage extends StatelessWidget {
  final String error;

  const _ErrorPage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'The page you are looking for does not exist.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go(RoutePaths.dashboard),
                icon: const Icon(Icons.home),
                label: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
