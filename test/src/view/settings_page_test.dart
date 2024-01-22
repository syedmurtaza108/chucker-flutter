import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/helper/http_methods.dart';
import 'package:chucker_flutter/src/view/helper/languages.dart';
import 'package:chucker_flutter/src/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late final SharedPreferencesManager sharedPreferencesManager;

  setUpAll(() {
    sharedPreferencesManager = SharedPreferencesManager.getInstance(
      initData: false,
    );
  });

  testWidgets(
    'Notification on/off settings should be saved in shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final settings = await sharedPreferencesManager.getSettings();

      expect(settings.showNotification, true);

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      final switches = find.byType(Switch).evaluate();

      await tester.tap(find.byWidget(switches.first.widget));
      await tester.pumpAndSettle();

      final newSettings = await sharedPreferencesManager.getSettings();

      expect(newSettings.showNotification, false);
    },
  );

  testWidgets(
    'Show Requests Stats on/off settings should be saved in shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final settings = await sharedPreferencesManager.getSettings();

      expect(settings.showRequestsStats, true);

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      final switches = find.byType(Switch).evaluate();
      final finderShowRequestSwitch =
          find.byWidget(switches.elementAt(1).widget);

      await tester.dragUntilVisible(
        finderShowRequestSwitch,
        find.byType(ListView),
        const Offset(0, 500),
      );

      await tester.tap(find.byWidget(switches.elementAt(1).widget));
      await tester.pumpAndSettle();

      final newSettings = await sharedPreferencesManager.getSettings();

      expect(newSettings.showRequestsStats, false);
    },
  );

  testWidgets(
    'Delete confirmation dialog on/off settings should be saved in shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final settings = await sharedPreferencesManager.getSettings();

      expect(settings.showDeleteConfirmDialog, true);

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      final switches = find.byType(Switch).evaluate();
      final finderDeleteDioSwitch = find.byWidget(switches.elementAt(2).widget);

      //Scrolling screen because the switch is at the bottom of screen
      await tester.dragUntilVisible(
        finderDeleteDioSwitch,
        find.byType(ListView),
        const Offset(0, 500),
      );

      await tester.tap(finderDeleteDioSwitch);
      await tester.pumpAndSettle();

      final newSettings = await sharedPreferencesManager.getSettings();

      expect(newSettings.showDeleteConfirmDialog, false);
    },
  );

  testWidgets(
    'Duration slider should save duration in shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final settings = await sharedPreferencesManager.getSettings();

      expect(settings.duration.inSeconds, 2);

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      final sliders = find.byType(Slider).evaluate();

      //Moving slider to current value (ie.2) + 4, so final value should be 6
      await tester.drag(
        find.byWidget(sliders.first.widget),
        const Offset(4, 0),
      );

      await tester.pumpAndSettle();

      final newSettings = await sharedPreferencesManager.getSettings();

      expect(newSettings.duration.inSeconds, 6);
    },
  );

  testWidgets(
    'Threshold slider should save api throshold in shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final settings = await sharedPreferencesManager.getSettings();

      expect(settings.apiThresholds, 100);

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      final sliders = find.byType(Slider).evaluate();

      //Scrolling screen because the switch is at the bottom of screen
      await tester.dragUntilVisible(
        find.byWidget(sliders.elementAt(1).widget),
        find.byType(Column),
        const Offset(0, 10),
      );

      //Moving slider to its last value i.e 1000
      await tester.drag(
        find.byWidget(sliders.elementAt(1).widget),
        const Offset(1000, 0),
      );

      await tester.pumpAndSettle();

      final newSettings = await sharedPreferencesManager.getSettings();

      expect(newSettings.apiThresholds, 1000);
    },
  );

  testWidgets(
    'Alignment menu should save notification alignment in shared prefs',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final settings = await sharedPreferencesManager.getSettings();

      expect(settings.notificationAlignment, Alignment.bottomCenter);

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      final menu = find.byType(PopupMenuButton).evaluate();

      //Alignment menu becomes visible
      await tester.tap(find.byWidget(menu.first.widget));
      await tester.pumpAndSettle();

      //Click on BottomLeft
      await tester.tap(find.text('BottomLeft'));
      await tester.pumpAndSettle();

      final newSettings = await sharedPreferencesManager.getSettings();

      expect(newSettings.notificationAlignment, Alignment.bottomLeft);
    },
  );

  testWidgets(
    'Httpm Methods menu should save default method in shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final settings = await sharedPreferencesManager.getSettings();

      expect(settings.httpMethod, HttpMethod.none);

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      final menu = find.byType(PopupMenuButton).evaluate();

      //Http method menu becomes visible
      await tester.tap(find.byWidget(menu.elementAt(1).widget));
      await tester.pumpAndSettle();

      //Click on Delete method
      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();

      final newSettings = await sharedPreferencesManager.getSettings();

      expect(newSettings.httpMethod, HttpMethod.delete);
    },
  );

  testWidgets(
    'Language menu should save language in shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final settings = await sharedPreferencesManager.getSettings();

      expect(settings.language, Language.english);

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      final menu = find.byType(PopupMenuButton).evaluate();

      await tester.dragUntilVisible(
        find.byWidget(menu.elementAt(2).widget),
        find.byType(ListView),
        const Offset(0, 500),
      );

      //Http method menu becomes visible
      await tester.tap(find.byWidget(menu.elementAt(2).widget));
      await tester.pumpAndSettle();

      //Click on Delete method
      await tester.tap(find.text('urdu'));
      await tester.pumpAndSettle();

      final newSettings = await sharedPreferencesManager.getSettings();

      expect(newSettings.language, Language.urdu);
    },
  );
}
