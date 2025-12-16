import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('should display text correctly', (WidgetTester tester) async {
      const buttonText = 'Test Button';
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: buttonText,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text(buttonText), findsOneWidget);
      expect(pressed, false);
    });

    testWidgets('should call onPressed callback when tapped',
        (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Tap Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('should use default primary color when backColor is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final buttonStyle = elevatedButton.style!;
      final backgroundColor = buttonStyle.backgroundColor!.resolve({});

      expect(backgroundColor, primaryColor);
    });

    testWidgets('should use custom backColor when provided',
        (WidgetTester tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
              backColor: customColor,
            ),
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final buttonStyle = elevatedButton.style!;
      final backgroundColor = buttonStyle.backgroundColor!.resolve({});

      expect(backgroundColor, customColor);
    });

    testWidgets('should apply custom foreColor to text',
        (WidgetTester tester) async {
      const customForeColor = Colors.yellow;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
              foreColor: customForeColor,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Button'));
      expect(textWidget.style!.color, customForeColor);
    });

    testWidgets('should apply custom padding when provided',
        (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(20);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
              padding: customPadding,
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Padding),
        ),
      );

      expect(padding.padding, customPadding);
    });

    testWidgets('should use zero padding when padding is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Padding),
        ),
      );

      expect(padding.padding, EdgeInsets.zero);
    });
  });
}
