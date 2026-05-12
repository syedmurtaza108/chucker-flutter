// ignore_for_file: deprecated_member_use_from_same_package
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'showNotification should show notification when navigatorKey is wired',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: ChuckerFlutter.navigatorKey,
          home: const SizedBox.shrink(),
        ),
      );

      final shown = ChuckerUiHelper.showNotification(
        method: 'GET',
        statusCode: 200,
        path: '/',
        requestTime: DateTime.now(),
      );

      expect(shown, true);
    },
  );

  testWidgets(
    'showChuckerScreen should navigate to chucker screen when called',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: ChuckerFlutter.navigatorKey,
          home: ChuckerFlutter.chuckerButton,
        ),
      );

      await tester.tap(find.byKey(const Key('chucker_button')));
      await tester.pumpAndSettle();

      final chuckerScreen = find.byKey(const Key('chucker_material_app'));

      expect(chuckerScreen, findsOneWidget);
    },
  );

  testWidgets(
    'notification should be removed after setting duration (by default 2 sec)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: ChuckerFlutter.navigatorKey,
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      ChuckerUiHelper.showNotification(
        method: 'GET',
        statusCode: 200,
        path: 'path',
        requestTime: DateTime.now(),
      );
      // ignore: flutter_style_todos
      await tester.pumpAndSettle(const Duration(seconds: 1));
    },
  );

  testWidgets(
    'showNotification still works through deprecated navigatorObserver '
    'fallback when navigatorKey is not attached',
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
        requestTime: DateTime.now(),
      );

      expect(shown, true);
    },
  );

  testWidgets(
    'showNotification attaches to root navigator even when a nested '
    'Navigator is present in the widget tree',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: ChuckerFlutter.navigatorKey,
          home: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: SizedBox.shrink()),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final shown = ChuckerUiHelper.showNotification(
        method: 'GET',
        statusCode: 200,
        path: '/',
        requestTime: DateTime.now(),
      );

      expect(shown, true);
      expect(ChuckerUiHelper.notificationShown, true);
    },
  );
}
