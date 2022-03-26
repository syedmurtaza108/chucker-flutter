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
}
