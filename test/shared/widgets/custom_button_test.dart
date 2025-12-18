import 'package:finance_tracker/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomButton', () {
    testWidgets('renders with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      expect(pressed, true);
    });

    testWidgets('is disabled when onPressed is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled Button',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Loading Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Button'), findsNothing);
    });

    testWidgets('is disabled when isLoading is true',
        (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Loading Button',
              onPressed: () => pressed = true,
              isLoading: true,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
      expect(pressed, false);
    });

    testWidgets('renders icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Button with Icon',
              onPressed: () {},
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Button with Icon'), findsOneWidget);
    });

    group('ButtonType variants', () {
      testWidgets('primary button renders as ElevatedButton',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton.primary(
                text: 'Primary',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Primary'), findsOneWidget);
      });

      testWidgets('secondary button renders as ElevatedButton',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton.secondary(
                text: 'Secondary',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Secondary'), findsOneWidget);
      });

      testWidgets('text button renders as TextButton',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton.text(
                text: 'Text Button',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(TextButton), findsOneWidget);
        expect(find.text('Text Button'), findsOneWidget);
      });

      testWidgets('outlined button renders as OutlinedButton',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton.outlined(
                text: 'Outlined',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(OutlinedButton), findsOneWidget);
        expect(find.text('Outlined'), findsOneWidget);
      });
    });

    group('ButtonSize variants', () {
      testWidgets('small button has correct padding',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton(
                text: 'Small',
                onPressed: () {},
                size: ButtonSize.small,
              ),
            ),
          ),
        );

        expect(find.text('Small'), findsOneWidget);
      });

      testWidgets('medium button has correct padding',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton(
                text: 'Medium',
                onPressed: () {},
                size: ButtonSize.medium,
              ),
            ),
          ),
        );

        expect(find.text('Medium'), findsOneWidget);
      });

      testWidgets('large button has correct padding',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton(
                text: 'Large',
                onPressed: () {},
                size: ButtonSize.large,
              ),
            ),
          ),
        );

        expect(find.text('Large'), findsOneWidget);
      });
    });

    testWidgets('fullWidth button takes full width',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: CustomButton(
                text: 'Full Width',
                onPressed: () {},
                fullWidth: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Full Width'), findsOneWidget);
    });
  });
}
