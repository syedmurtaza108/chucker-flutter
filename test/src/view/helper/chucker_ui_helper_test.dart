import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'showNotification should show notification when called',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [ChuckerFlutter.navigatorObserver],
          home: const SizedBox.shrink(),
        ),
      );

      final shown = ChuckerUiHelper.showNotification(
        method: 'GET',
        statusCode: 200,
        path: '/',
      );

      expect(shown, true);
    },
  );

  testWidgets(
    'showChuckerScreen should navigate to chucker screen when called',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [ChuckerFlutter.navigatorObserver],
          home: ChuckerFlutter.chuckerButton,
        ),
      );

      await tester.tap(find.byKey(const Key('chucker_button')));
      await tester.pumpAndSettle();

      final chuckerScreen = find.byKey(const Key('chucker_material_app'));

      expect(chuckerScreen, findsOneWidget);
    },
  );
}
