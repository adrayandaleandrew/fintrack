import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/di/injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/currency/presentation/bloc/currency_bloc.dart';

/// Application entry point
///
/// Initializes dependencies and runs the app.
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await initializeDependencies();

  // Set up BLoC observer for debugging
  Bloc.observer = AppBlocObserver();

  // Run the app
  runApp(const FinanceTrackerApp());
}

/// Main application widget
class FinanceTrackerApp extends StatelessWidget {
  const FinanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create router
    final router = AppRouter.createRouter();

    return MultiBlocProvider(
      providers: [
        // Provide AuthBloc at app level
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),

        // Currency BLoC for multi-currency support
        BlocProvider<CurrencyBloc>(
          create: (context) => sl<CurrencyBloc>(),
        ),

        // Additional BLoCs will be added here as features are implemented
        // BlocProvider<AccountBloc>(create: (context) => sl<AccountBloc>()),
        // BlocProvider<TransactionBloc>(create: (context) => sl<TransactionBloc>()),
        // etc.
      ],
      child: MaterialApp.router(
        // App configuration
        title: 'Finance Tracker',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Router configuration
        routerConfig: router,
      ),
    );
  }
}

/// BLoC observer for debugging
///
/// Logs all BLoC events, changes, and errors.
/// Useful for debugging state management issues.
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('BLoC Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('BLoC Event: ${bloc.runtimeType}, Event: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('BLoC Change: ${bloc.runtimeType}, Change: $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('BLoC Transition: ${bloc.runtimeType}, Transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('BLoC Error: ${bloc.runtimeType}, Error: $error');
    debugPrint('StackTrace: $stackTrace');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('BLoC Closed: ${bloc.runtimeType}');
  }
}
