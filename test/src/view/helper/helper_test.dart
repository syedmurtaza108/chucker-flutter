import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('ChuckerButton should be shown everywhere, where it is placed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text('Testing Chucker Button'),
                  ChuckerFlutter.chuckerButton,
                ],
              ),
            ),
            ChuckerFlutter.chuckerButton,
          ],
        ),
      ),
    );

    final button = find.byKey(const Key('chucker_button'));

    expect(button, findsNWidgets(2));
  });
}
