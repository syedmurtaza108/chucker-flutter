import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('`isNotZero` should return true if number is > or < 0', () {
    expect(1.isNotZero, true);
    expect((-1).isNotZero, true);
  });

  test('isNotZero should return false if number is  0', () {
    expect(0.isNotZero, false);
  });

  testWidgets(
    '`theme` should return theme of current context',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.transparent),
          builder: (BuildContext context, _) {
            expect(context.theme.primaryColor, Colors.transparent);
            return const SizedBox.shrink();
          },
        ),
      );
    },
  );

  testWidgets(
    '`navigator` should return navigator of current context',
    (WidgetTester tester) async {
      final observer = NavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.transparent),
          navigatorObservers: [observer],
          home: Builder(
            builder: (context) {
              expect(context.navigator, observer.navigator);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    },
  );

  test('isNotZero should handle large positive numbers', () {
    expect(1000000.isNotZero, true);
    expect(999999999.isNotZero, true);
  });

  test('isNotZero should handle large negative numbers', () {
    expect((-1000000).isNotZero, true);
    expect((-999999999).isNotZero, true);
  });

  test('isNotZero should handle very small numbers', () {
    expect(0.0000001.isNotZero, true);
    expect((-0.0000001).isNotZero, true);
  });

  test('isNotZero should handle double zero', () {
    expect(0.0.isNotZero, false);
    expect((-0.0).isNotZero, false);
  });

  testWidgets(
    'textTheme should return text theme from current context',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 20),
            ),
          ),
          builder: (BuildContext context, _) {
            expect(context.textTheme.bodyLarge!.fontSize, 20);
            return const SizedBox.shrink();
          },
        ),
      );
    },
  );
}
