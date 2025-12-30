import 'package:chucker_flutter/src/view/widgets/alignment_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlignmentMenu', () {
    testWidgets('should display title correctly', (WidgetTester tester) async {
      const title = 'Select Alignment';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlignmentMenu(
              notificationAlignment: Alignment.center,
              title: title,
              onSelect: (alignment) {},
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should display popup menu when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlignmentMenu(
              notificationAlignment: Alignment.center,
              title: 'Alignment',
              onSelect: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AlignmentMenu));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuButton), findsOneWidget);
      // Should show alignment options
      expect(find.text('Center'), findsOneWidget);
      expect(find.text('TopLeft'), findsOneWidget);
      expect(find.text('BottomRight'), findsOneWidget);
    });

    testWidgets('should show all 9 alignment options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlignmentMenu(
              notificationAlignment: Alignment.center,
              title: 'Alignment',
              onSelect: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AlignmentMenu));
      await tester.pumpAndSettle();

      expect(find.text('BottomCenter'), findsOneWidget);
      expect(find.text('BottomLeft'), findsOneWidget);
      expect(find.text('BottomRight'), findsOneWidget);
      expect(find.text('Center'), findsOneWidget);
      expect(find.text('CenterLeft'), findsOneWidget);
      expect(find.text('CenterRight'), findsOneWidget);
      expect(find.text('TopCenter'), findsOneWidget);
      expect(find.text('TopLeft'), findsOneWidget);
      expect(find.text('TopRight'), findsOneWidget);
    });

    testWidgets('should call onSelect when alignment is tapped',
        (WidgetTester tester) async {
      Alignment? selectedAlignment;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlignmentMenu(
              notificationAlignment: Alignment.center,
              title: 'Alignment',
              onSelect: (alignment) => selectedAlignment = alignment,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AlignmentMenu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('TopLeft'));
      await tester.pumpAndSettle();

      expect(selectedAlignment, Alignment.topLeft);
    });

    testWidgets('should show checked icon for selected alignment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlignmentMenu(
              notificationAlignment: Alignment.bottomRight,
              title: 'Alignment',
              onSelect: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AlignmentMenu));
      await tester.pumpAndSettle();

      // Should find radio_button_checked icon for selected alignment
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      // Should find 8 unchecked icons (9 total - 1 checked)
      expect(find.byIcon(Icons.radio_button_off), findsNWidgets(8));
    });

    testWidgets('should update selection on multiple taps',
        (WidgetTester tester) async {
      final selectedAlignments = <Alignment>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlignmentMenu(
              notificationAlignment: Alignment.center,
              title: 'Alignment',
              onSelect: selectedAlignments.add,
            ),
          ),
        ),
      );

      // First selection
      await tester.tap(find.byType(AlignmentMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('TopLeft'));
      await tester.pumpAndSettle();

      // Second selection
      await tester.tap(find.byType(AlignmentMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BottomRight'));
      await tester.pumpAndSettle();

      expect(selectedAlignments.length, 2);
      expect(selectedAlignments[0], Alignment.topLeft);
      expect(selectedAlignments[1], Alignment.bottomRight);
    });
  });
}
