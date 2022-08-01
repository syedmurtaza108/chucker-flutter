import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Notification should appear when showNotification called ',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [ChuckerFlutter.navigatorObserver],
          home: Scaffold(appBar: AppBar()),
        ),
      );

      ChuckerUiHelper.showNotification(
        method: 'GET',
        statusCode: 200,
        path: 'path',
        requestTime: DateTime.now(),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(ChuckerUiHelper.notificationShown, true);
    },
  );
}
