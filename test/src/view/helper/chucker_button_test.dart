import 'package:chucker_flutter/src/view/helper/chucker_button.dart';
import 'package:chucker_flutter/src/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChuckerButton', () {
    testWidgets('should return singleton instance',
        (WidgetTester tester) async {
      final instance1 = ChuckerButton.getInstance();
      final instance2 = ChuckerButton.getInstance();

      expect(instance1, same(instance2));
    });

    testWidgets('should have correct key', (WidgetTester tester) async {
      final button = ChuckerButton.getInstance();

      expect(button.key, const Key('chucker_button'));
    });

    testWidgets('should render PrimaryButton', (WidgetTester tester) async {
      final button = ChuckerButton.getInstance();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('should display correct text', (WidgetTester tester) async {
      final button = ChuckerButton.getInstance();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      expect(find.text('Open Chucker Flutter'), findsOneWidget);
    });

    testWidgets('should have white foreground color',
        (WidgetTester tester) async {
      final button = ChuckerButton.getInstance();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      final primaryButton = tester.widget<PrimaryButton>(
        find.byType(PrimaryButton),
      );

      expect(primaryButton.foreColor, Colors.white);
    });

    testWidgets('should be tappable', (WidgetTester tester) async {
      final button = ChuckerButton.getInstance();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: button,
          ),
        ),
      );

      // Should not throw when tapped
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      // The button should be tappable (checking it doesn't throw)
      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.onPressed, isNotNull);
    });

    testWidgets('multiple calls to getInstance should return same instance',
        (WidgetTester tester) async {
      final instances = List.generate(5, (_) => ChuckerButton.getInstance());

      for (var i = 1; i < instances.length; i++) {
        expect(instances[i], same(instances[0]));
      }
    });
  });
}
