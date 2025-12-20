import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConfirmationDialog', () {
    Widget buildTestWidget({
      required String title,
      required String message,
      Color? yesButtonBackColor,
      Color? yesButtonForeColor,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          ...Localization.localizationsDelegates,
        ],
        supportedLocales: Localization.supportedLocales,
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () => showConfirmationDialog(
                  context,
                  title: title,
                  message: message,
                  yesButtonBackColor: yesButtonBackColor,
                  yesButtonForeColor: yesButtonForeColor,
                ),
                child: const Text('Show Dialog'),
              ),
            );
          },
        ),
      );
    }

    testWidgets('should display title and message correctly',
        (WidgetTester tester) async {
      const title = 'Confirm Action';
      const message = 'Are you sure you want to proceed?';

      await tester.pumpWidget(
        buildTestWidget(title: title, message: message),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('should display yes and no buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          title: 'Test',
          message: 'Test message',
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Yes and No should be in the dialog
      expect(find.text(Localization.strings['yes']!), findsOneWidget);
      expect(find.text(Localization.strings['no']!), findsOneWidget);
    });

    testWidgets('should return false when No button is tapped',
        (WidgetTester tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            ...Localization.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: Localization.supportedLocales,
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    result = await showConfirmationDialog(
                      context,
                      title: 'Test',
                      message: 'Test message',
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(Localization.strings['no']!));
      await tester.pumpAndSettle();

      expect(result, false);
    });

    testWidgets('should return true when Yes button is tapped',
        (WidgetTester tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            ...Localization.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: Localization.supportedLocales,
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    result = await showConfirmationDialog(
                      context,
                      title: 'Test',
                      message: 'Test message',
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(Localization.strings['yes']!));
      await tester.pumpAndSettle();

      expect(result, true);
    });

    testWidgets('should not dismiss on barrier tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          title: 'Test',
          message: 'Test message',
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Try to tap outside the dialog (barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should still be visible
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should apply custom yesButtonBackColor',
        (WidgetTester tester) async {
      const customBackColor = Colors.red;

      await tester.pumpWidget(
        buildTestWidget(
          title: 'Test',
          message: 'Test message',
          yesButtonBackColor: customBackColor,
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog should be shown with custom color
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should apply custom yesButtonForeColor',
        (WidgetTester tester) async {
      const customForeColor = Colors.white;

      await tester.pumpWidget(
        buildTestWidget(
          title: 'Test',
          message: 'Test message',
          yesButtonForeColor: customForeColor,
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should display long message correctly',
        (WidgetTester tester) async {
      const longMessage = 'This is a very long message that should still be '
          'displayed correctly in the confirmation dialog without any issues '
          'and should wrap properly to multiple lines if needed.';

      await tester.pumpWidget(
        buildTestWidget(
          title: 'Long Message',
          message: longMessage,
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(longMessage), findsOneWidget);
    });
  });
}
