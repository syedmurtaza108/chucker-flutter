import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/widgets/menu_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MenuButtons', () {
    Widget buildTestWidget({
      required bool enableDelete,
      required VoidCallback onDelete,
      required VoidCallback onSettings,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: Localization.supportedLocales,
        home: Scaffold(
          body: MenuButtons(
            enableDelete: enableDelete,
            onDelete: onDelete,
            onSettings: onSettings,
          ),
        ),
      );
    }

    testWidgets('should display popup menu button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          enableDelete: true,
          onDelete: () {},
          onSettings: () {},
        ),
      );

      expect(find.byType(PopupMenuButton<int>), findsOneWidget);
    });

    testWidgets('should show delete and settings menu items when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          enableDelete: true,
          onDelete: () {},
          onSettings: () {},
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();

      expect(find.text(Localization.strings['delete']!), findsOneWidget);
      expect(find.text(Localization.strings['settings']!), findsOneWidget);
    });

    testWidgets('should call onDelete when delete menu item is tapped',
        (WidgetTester tester) async {
      var deleteCalled = false;

      await tester.pumpWidget(
        buildTestWidget(
          enableDelete: true,
          onDelete: () => deleteCalled = true,
          onSettings: () {},
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();

      await tester.tap(find.text(Localization.strings['delete']!));
      await tester.pumpAndSettle();

      expect(deleteCalled, true);
    });

    testWidgets('should call onSettings when settings menu item is tapped',
        (WidgetTester tester) async {
      var settingsCalled = false;

      await tester.pumpWidget(
        buildTestWidget(
          enableDelete: true,
          onDelete: () {},
          onSettings: () => settingsCalled = true,
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();

      await tester.tap(find.text(Localization.strings['settings']!));
      await tester.pumpAndSettle();

      expect(settingsCalled, true);
    });

    testWidgets('should disable delete menu item when enableDelete is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          enableDelete: false,
          onDelete: () {},
          onSettings: () {},
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();

      final deleteMenuItem = tester.widget<PopupMenuItem>(
        find.byKey(const ValueKey('menu_delete')),
      );

      expect(deleteMenuItem.enabled, false);
    });

    testWidgets('should enable delete menu item when enableDelete is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          enableDelete: true,
          onDelete: () {},
          onSettings: () {},
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();

      final deleteMenuItem = tester.widget<PopupMenuItem>(
        find.byKey(const ValueKey('menu_delete')),
      );

      expect(deleteMenuItem.enabled, true);
    });

    testWidgets('should always enable settings menu item',
        (WidgetTester tester) async {
      for (final enableDelete in [true, false]) {
        await tester.pumpWidget(
          buildTestWidget(
            enableDelete: enableDelete,
            onDelete: () {},
            onSettings: () {},
          ),
        );

        await tester.tap(find.byType(PopupMenuButton<int>));
        await tester.pumpAndSettle();

        final settingsMenuItem = tester.widget<PopupMenuItem>(
          find.byKey(const ValueKey('menu_settings')),
        );

        // Settings should always be enabled (no explicit enabled property set)
        expect(settingsMenuItem.enabled, true);

        // Close menu
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should not call onDelete when delete is disabled',
        (WidgetTester tester) async {
      var deleteCalled = false;

      await tester.pumpWidget(
        buildTestWidget(
          enableDelete: false,
          onDelete: () => deleteCalled = true,
          onSettings: () {},
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();

      // Try to tap the disabled delete button
      await tester.tap(find.text(Localization.strings['delete']!));
      await tester.pumpAndSettle();

      // Delete should not be called when disabled
      expect(deleteCalled, false);
    });

    testWidgets('should have correct keys for menu items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          enableDelete: true,
          onDelete: () {},
          onSettings: () {},
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('menu_delete')), findsOneWidget);
      expect(find.byKey(const ValueKey('menu_settings')), findsOneWidget);
    });
  });
}
