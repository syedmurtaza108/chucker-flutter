import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChuckerAppBar', () {
    testWidgets('should display title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ChuckerAppBar(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Chucker Flutter'), findsOneWidget);
    });

    testWidgets('should have correct preferredSize',
        (WidgetTester tester) async {
      final appBar = ChuckerAppBar(
        onBackPressed: () {},
      );

      expect(appBar.preferredSize, const Size.fromHeight(56));
    });

    testWidgets('should display back button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ChuckerAppBar(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byKey(const ValueKey('chucker_back_button')), findsOneWidget);
    });

    testWidgets('should call onBackPressed when back button is tapped',
        (WidgetTester tester) async {
      var backPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ChuckerAppBar(
              onBackPressed: () => backPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('chucker_back_button')));
      await tester.pump();

      expect(backPressed, true);
    });

    testWidgets('should have primary color as background',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ChuckerAppBar(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, primaryColor);
    });

    testWidgets('should display actions when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ChuckerAppBar(
              onBackPressed: () {},
              actions: [
                IconButton(
                  key: const ValueKey('action_button_1'),
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
                IconButton(
                  key: const ValueKey('action_button_2'),
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('action_button_1')), findsOneWidget);
      expect(find.byKey(const ValueKey('action_button_2')), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should not display actions when null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ChuckerAppBar(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.actions, null);
    });

    testWidgets('should have white text color for title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ChuckerAppBar(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      final titleText = tester.widget<Text>(find.text('Chucker Flutter'));
      expect(titleText.style!.color, Colors.white);
    });

    testWidgets('should render as PreferredSizeWidget',
        (WidgetTester tester) async {
      final appBar = ChuckerAppBar(
        onBackPressed: () {},
      );

      expect(appBar, isA<PreferredSizeWidget>());
    });

    testWidgets('should handle multiple actions', (WidgetTester tester) async {
      final actions = List.generate(
        5,
        (index) => IconButton(
          key: ValueKey('action_$index'),
          icon: const Icon(Icons.star),
          onPressed: () {},
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ChuckerAppBar(
              onBackPressed: () {},
              actions: actions,
            ),
          ),
        ),
      );

      for (var i = 0; i < 5; i++) {
        expect(find.byKey(ValueKey('action_$i')), findsOneWidget);
      }
    });

    testWidgets('back button should be tappable multiple times',
        (WidgetTester tester) async {
      var backPressCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ChuckerAppBar(
              onBackPressed: () => backPressCount++,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('chucker_back_button')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('chucker_back_button')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('chucker_back_button')));
      await tester.pump();

      expect(backPressCount, 3);
    });
  });
}
