import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/widgets/sizeable_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SizeableTextButton', () {
    testWidgets('should display text correctly', (WidgetTester tester) async {
      const buttonText = 'Click Me';
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeableTextButton(
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
            body: SizeableTextButton(
              text: 'Tap Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('should apply custom height when provided',
        (WidgetTester tester) async {
      const customHeight = 100.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeableTextButton(
              text: 'Button',
              onPressed: () {},
              height: customHeight,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(TextButton),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.height, customHeight);
    });

    testWidgets('should apply custom width when provided',
        (WidgetTester tester) async {
      const customWidth = 200.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeableTextButton(
              text: 'Button',
              onPressed: () {},
              width: customWidth,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(TextButton),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, customWidth);
    });

    testWidgets('should apply both custom height and width',
        (WidgetTester tester) async {
      const customHeight = 80.0;
      const customWidth = 150.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeableTextButton(
              text: 'Button',
              onPressed: () {},
              height: customHeight,
              width: customWidth,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(TextButton),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.height, customHeight);
      expect(sizedBox.width, customWidth);
    });

    testWidgets('should use custom style when provided',
        (WidgetTester tester) async {
      const customStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeableTextButton(
              text: 'Button',
              onPressed: () {},
              style: customStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Button'));
      expect(textWidget.style!.fontSize, customStyle.fontSize);
      expect(textWidget.style!.fontWeight, customStyle.fontWeight);
    });

    testWidgets('should use default style with primary color when style is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeableTextButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Button'));
      expect(textWidget.style!.color, primaryColor);
    });

    testWidgets('should have no height constraint when height is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeableTextButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(TextButton),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.height, null);
    });

    testWidgets('should have no width constraint when width is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeableTextButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(TextButton),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, null);
    });
  });
}
