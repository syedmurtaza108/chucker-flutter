import 'package:chucker_flutter/src/view/widgets/stats_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StatsTile', () {
    testWidgets('should display title correctly', (WidgetTester tester) async {
      const title = 'Total Requests';
      const stats = '42';
      const backColor = Colors.blue;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                StatsTile(
                  title: title,
                  stats: stats,
                  backColor: backColor,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should display stats correctly', (WidgetTester tester) async {
      const title = 'Success';
      const stats = '100';
      const backColor = Colors.green;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                StatsTile(
                  title: title,
                  stats: stats,
                  backColor: backColor,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text(stats), findsOneWidget);
    });

    testWidgets('should apply custom backColor', (WidgetTester tester) async {
      const backColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                StatsTile(
                  title: 'Failed',
                  stats: '5',
                  backColor: backColor,
                ),
              ],
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, backColor);
    });

    testWidgets('should be expanded within row', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                StatsTile(
                  title: 'Test',
                  stats: '10',
                  backColor: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('should render all children correctly',
        (WidgetTester tester) async {
      const title = 'Pending';
      const stats = '3';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                StatsTile(
                  title: title,
                  stats: stats,
                  backColor: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(stats), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should handle empty stats string',
        (WidgetTester tester) async {
      const title = 'Empty';
      const stats = '';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                StatsTile(
                  title: title,
                  stats: stats,
                  backColor: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      // Empty string still creates a Text widget but with no visible content
      expect(find.byType(Text), findsNWidgets(2)); // title and stats
    });

    testWidgets('should handle long stats string',
        (WidgetTester tester) async {
      const title = 'Long Stats';
      const stats = '123456789';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                StatsTile(
                  title: title,
                  stats: stats,
                  backColor: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(stats), findsOneWidget);
    });

    testWidgets('should have proper spacing with SizedBox widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                StatsTile(
                  title: 'Test',
                  stats: '1',
                  backColor: Colors.teal,
                ),
              ],
            ),
          ),
        ),
      );

      // Should have 3 SizedBox widgets for spacing
      expect(find.byType(SizedBox), findsNWidgets(3));
    });
  });
}
