import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/categories/presentation/pages/category_list_page.dart';
import 'route_names.dart';
import 'route_paths.dart';

/// Application router configuration
///
/// Configures all routes for the application using go_router.
/// Handles navigation, redirects, and route guards.
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

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
          builder: (context, state) => const _PlaceholderPage(
            title: 'Dashboard',
            description: 'Dashboard will show summary cards, charts, and recent transactions',
          ),
        ),

        // ==================== Transactions ====================
        GoRoute(
          path: RoutePaths.transactions,
          name: RouteNames.transactions,
          builder: (context, state) => const _PlaceholderPage(
            title: 'Transactions',
            description: 'Transaction list with filtering and search',
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: RouteNames.addTransaction,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Add Transaction',
                description: 'Form to add new transaction',
              ),
            ),
            GoRoute(
              path: ':id',
              name: RouteNames.transactionDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return _PlaceholderPage(
                  title: 'Transaction Detail',
                  description: 'Details for transaction $id',
                );
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
          builder: (context, state) => const _PlaceholderPage(
            title: 'Accounts',
            description: 'List of all accounts',
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
          builder: (context, state) => const CategoryListPage(
            userId: 'user_1', // TODO: Get from auth state
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
          builder: (context, state) => const _PlaceholderPage(
            title: 'Budgets',
            description: 'List of all budgets with progress',
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: RouteNames.addBudget,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Add Budget',
                description: 'Form to add new budget',
              ),
            ),
            GoRoute(
              path: ':id',
              name: RouteNames.budgetDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return _PlaceholderPage(
                  title: 'Budget Detail',
                  description: 'Details for budget $id',
                );
              },
            ),
            GoRoute(
              path: ':id/edit',
              name: RouteNames.editBudget,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return _PlaceholderPage(
                  title: 'Edit Budget',
                  description: 'Edit budget $id',
                );
              },
            ),
          ],
        ),

        // ==================== Recurring Transactions ====================
        GoRoute(
          path: RoutePaths.recurringTransactions,
          name: RouteNames.recurringTransactions,
          builder: (context, state) => const _PlaceholderPage(
            title: 'Recurring Transactions',
            description: 'List of all recurring transactions',
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: RouteNames.addRecurringTransaction,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Add Recurring Transaction',
                description: 'Form to add new recurring transaction',
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
                return _PlaceholderPage(
                  title: 'Edit Recurring Transaction',
                  description: 'Edit recurring transaction $id',
                );
              },
            ),
          ],
        ),

        // ==================== Reports ====================
        GoRoute(
          path: RoutePaths.reports,
          name: RouteNames.reports,
          builder: (context, state) => const _PlaceholderPage(
            title: 'Reports',
            description: 'Reports overview with charts and analytics',
          ),
          routes: [
            GoRoute(
              path: 'expense-breakdown',
              name: RouteNames.expenseBreakdown,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Expense Breakdown',
                description: 'Pie chart showing expense by category',
              ),
            ),
            GoRoute(
              path: 'income-trends',
              name: RouteNames.incomeTrends,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Income Trends',
                description: 'Line chart showing income over time',
              ),
            ),
            GoRoute(
              path: 'monthly-comparison',
              name: RouteNames.monthlyComparison,
              builder: (context, state) => const _PlaceholderPage(
                title: 'Monthly Comparison',
                description: 'Bar chart comparing monthly spending',
              ),
            ),
          ],
        ),

        // ==================== Settings ====================
        GoRoute(
          path: RoutePaths.settings,
          name: RouteNames.settings,
          builder: (context, state) => const _PlaceholderPage(
            title: 'Settings',
            description: 'App settings and preferences',
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
