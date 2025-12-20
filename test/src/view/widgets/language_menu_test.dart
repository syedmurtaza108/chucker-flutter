import 'package:chucker_flutter/src/view/helper/languages.dart';
import 'package:chucker_flutter/src/view/widgets/language_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LanguagesMenu', () {
    testWidgets('should display current language name',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.english,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('english'), findsOneWidget);
    });

    testWidgets('should display popup menu when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.english,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LanguagesMenu));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuButton), findsOneWidget);
    });

    testWidgets('should show all language options when menu is opened',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.english,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LanguagesMenu));
      await tester.pumpAndSettle();

      // Should show all languages from Language enum
      for (final language in Language.values) {
        expect(find.text(language.name), findsOneWidget);
      }
    });

    testWidgets('should call onSelect when a language is tapped',
        (WidgetTester tester) async {
      Language? selectedLanguage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.english,
              onSelect: (language) => selectedLanguage = language,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LanguagesMenu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('urdu'));
      await tester.pumpAndSettle();

      expect(selectedLanguage, Language.urdu);
    });

    testWidgets('should show checked icon for selected language',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.urdu,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LanguagesMenu));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      // Number of unchecked = total languages - 1 checked
      expect(
        find.byIcon(Icons.radio_button_off),
        findsNWidgets(Language.values.length - 1),
      );
    });

    testWidgets('should update displayed language when language prop changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.english,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('english'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.urdu,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('urdu'), findsOneWidget);
    });

    testWidgets('should apply border radius to container',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.english,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(LanguagesMenu),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('should handle multiple selections',
        (WidgetTester tester) async {
      final selectedLanguages = <Language>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.english,
              onSelect: selectedLanguages.add,
            ),
          ),
        ),
      );

      // Select Urdu
      await tester.tap(find.byType(LanguagesMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('urdu'));
      await tester.pumpAndSettle();

      // Select English
      await tester.tap(find.byType(LanguagesMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('english'));
      await tester.pumpAndSettle();

      expect(selectedLanguages.length, 2);
      expect(selectedLanguages[0], Language.urdu);
      expect(selectedLanguages[1], Language.english);
    });

    testWidgets('should show all languages dynamically from Language.values',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.english,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LanguagesMenu));
      await tester.pumpAndSettle();

      // Verify the number of menu items matches Language enum values
      final menuItems = tester.widgetList<PopupMenuItem<Language>>(
        find.byType(PopupMenuItem<Language>),
      );
      expect(menuItems.length, Language.values.length);
    });

    testWidgets('should properly center language name in container',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguagesMenu(
              language: Language.english,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      final center = tester.widget<Center>(
        find.descendant(
          of: find.byType(Container),
          matching: find.byType(Center),
        ),
      );

      expect(center, isNotNull);
    });
  });
}
