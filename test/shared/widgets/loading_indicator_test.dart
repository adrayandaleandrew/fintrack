import 'package:finance_tracker/shared/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingIndicator', () {
    testWidgets('renders CircularProgressIndicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('small factory creates small indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator.small(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('medium factory creates medium indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator.medium(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('large factory creates large indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator.large(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders within Center widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(LoadingIndicator),
          matching: find.byType(Center),
        ),
        findsOneWidget,
      );
    });
  });

  group('LoadingOverlay', () {
    testWidgets('shows overlay when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              child: Text('Child Widget'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Child Widget'), findsOneWidget);
    });

    testWidgets('hides overlay when isLoading is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: false,
              child: Text('Child Widget'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Child Widget'), findsOneWidget);
    });

    testWidgets('shows message when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              message: 'Loading data...',
              child: Text('Child Widget'),
            ),
          ),
        ),
      );

      expect(find.text('Loading data...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('does not show message when isLoading is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: false,
              message: 'Loading data...',
              child: Text('Child Widget'),
            ),
          ),
        ),
      );

      expect(find.text('Loading data...'), findsNothing);
    });

    testWidgets('renders using Stack', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              child: Text('Child Widget'),
            ),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(LoadingOverlay),
          matching: find.byType(Stack),
        ),
        findsOneWidget,
      );
    });
  });

  group('SkeletonLoader', () {
    testWidgets('renders shimmer effect', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
    });

    testWidgets('text factory creates text skeleton',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonLoader.text(),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
    });

    testWidgets('title factory creates title skeleton',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonLoader.title(),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
    });

    testWidgets('circle factory creates circle skeleton',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonLoader.circle(size: 50),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
    });

    testWidgets('renders with specified width', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(width: 200),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
    });
  });

  group('SkeletonCard', () {
    testWidgets('renders Card with skeleton elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonCard(),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(SkeletonLoader), findsWidgets);
    });

    testWidgets('contains multiple SkeletonLoader widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonCard(),
          ),
        ),
      );

      final skeletonLoaders = find.byType(SkeletonLoader);
      expect(skeletonLoaders, findsWidgets);
    });
  });

  group('SkeletonList', () {
    testWidgets('renders default 5 SkeletonCard items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonList(),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(SkeletonCard), findsNWidgets(5));
    });

    testWidgets('renders custom number of items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonList(itemCount: 3),
          ),
        ),
      );

      expect(find.byType(SkeletonCard), findsNWidgets(3));
    });

    testWidgets('uses NeverScrollableScrollPhysics',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonList(),
          ),
        ),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.physics, isA<NeverScrollableScrollPhysics>());
    });
  });
}
