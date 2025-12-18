import 'package:finance_tracker/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorView', () {
    testWidgets('renders with message and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Test error message',
            ),
          ),
        ),
      );

      expect(find.text('Test error message'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('renders with custom icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Test error',
              icon: Icons.warning,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('renders with title when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Test message',
              title: 'Test Title',
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry is provided',
        (WidgetTester tester) async {
      var retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Test error',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      expect(retried, true);
    });

    testWidgets('does not show retry button when onRetry is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Test error',
            ),
          ),
        ),
      );

      expect(find.text('Try Again'), findsNothing);
      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    group('Factory constructors', () {
      testWidgets('network factory creates network error',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorView.network(
                onRetry: () {},
              ),
            ),
          ),
        );

        expect(find.text('No Internet Connection'), findsOneWidget);
        expect(
            find.text('Please check your internet connection and try again.'),
            findsOneWidget);
        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      });

      testWidgets('server factory creates server error',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorView.server(
                onRetry: () {},
              ),
            ),
          ),
        );

        expect(find.text('Server Error'), findsOneWidget);
        expect(
            find.text(
                'Something went wrong on our end. Please try again later.'),
            findsOneWidget);
        expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      });

      testWidgets('server factory accepts custom message',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorView.server(
                message: 'Custom server error',
              ),
            ),
          ),
        );

        expect(find.text('Custom server error'), findsOneWidget);
      });

      testWidgets('notFound factory creates not found error',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorView.notFound(),
            ),
          ),
        );

        expect(find.text('Not Found'), findsOneWidget);
        expect(find.text('The requested resource was not found.'),
            findsOneWidget);
        expect(find.byIcon(Icons.search_off), findsOneWidget);
      });

      testWidgets('unauthorized factory creates unauthorized error',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorView.unauthorized(
                onRetry: () {},
              ),
            ),
          ),
        );

        expect(find.text('Unauthorized'), findsOneWidget);
        expect(find.text('Please log in to access this content.'),
            findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });

      testWidgets('generic factory creates generic error',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorView.generic(
                onRetry: () {},
              ),
            ),
          ),
        );

        expect(find.text('Error'), findsOneWidget);
        expect(find.text('An unexpected error occurred.'), findsOneWidget);
      });
    });
  });

  group('InlineError', () {
    testWidgets('renders with message and default icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InlineError(
              message: 'Inline error message',
            ),
          ),
        ),
      );

      expect(find.text('Inline error message'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('renders with custom icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InlineError(
              message: 'Test message',
              icon: Icons.warning_amber,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('renders within Container with decoration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InlineError(
              message: 'Test',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(InlineError),
          matching: find.byType(Container),
        ),
      );
      expect(container.decoration, isNotNull);
    });
  });
}
