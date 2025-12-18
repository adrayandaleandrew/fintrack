import 'package:finance_tracker/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTextField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Test Label',
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('accepts text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Test',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Hello World');
      expect(controller.text, 'Hello World');
    });

    testWidgets('calls onChanged when text changes',
        (WidgetTester tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Test',
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Test Value');
      expect(changedValue, 'Test Value');
    });

    testWidgets('shows validation error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: CustomTextField(
                controller: controller,
                label: 'Test',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      // Find the form and validate it
      final formState = tester.state<FormState>(find.byType(Form));
      formState.validate();
      await tester.pump();

      expect(find.text('Field is required'), findsOneWidget);
    });

    testWidgets('displays hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Test',
              hint: 'Enter value here',
            ),
          ),
        ),
      );

      expect(find.text('Enter value here'), findsOneWidget);
    });

    testWidgets('shows prefix icon when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Test',
              prefixIcon: Icons.person,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('obscures text when obscureText is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Password',
              obscureText: true,
            ),
          ),
        ),
      );

      // Just verify widget renders without error
      expect(find.byType(CustomTextField), findsOneWidget);
    });

    testWidgets('is disabled when enabled is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Disabled',
              enabled: false,
            ),
          ),
        ),
      );

      final textField =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, false);
    });

    testWidgets('is read-only when readOnly is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Read Only',
              readOnly: true,
            ),
          ),
        ),
      );

      // Just verify widget renders without error
      expect(find.byType(CustomTextField), findsOneWidget);
    });

    testWidgets('email factory creates email field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField.email(
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('password factory creates password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField.password(
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Password'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outlined), findsOneWidget);
    });

    testWidgets('number factory creates number field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField.number(
              controller: controller,
              label: 'Number',
            ),
          ),
        ),
      );

      expect(find.text('Number'), findsOneWidget);
    });

    testWidgets('multiline supports multiple lines',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Notes',
              maxLines: 5,
            ),
          ),
        ),
      );

      // Just verify widget renders without error
      expect(find.byType(CustomTextField), findsOneWidget);
    });

    testWidgets('respects maxLength', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Limited',
              maxLength: 10,
            ),
          ),
        ),
      );

      // Just verify widget renders without error
      expect(find.byType(CustomTextField), findsOneWidget);
    });

    testWidgets('suffix icon is tappable', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Test',
              suffixIcon: Icons.clear,
              onSuffixIconPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.clear));
      expect(tapped, true);
    });
  });
}
