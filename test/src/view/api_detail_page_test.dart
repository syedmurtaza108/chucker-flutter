import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/api_detail_page.dart';
import 'package:chucker_flutter/src/view/json_tree/json_tree.dart';
import 'package:chucker_flutter/src/view/widgets/sizeable_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'When page opened, three tabs should be loaded',
    (WidgetTester tester) async {
      final api = ApiResponse.mock();

      await tester.pumpWidget(MaterialApp(home: ApiDetailsPage(api: api)));
      await tester.pumpAndSettle();

      final tabBarView = find
          .byKey(const Key('api_detail_tabbar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      expect(tabBarView.children.length, 3);
    },
  );

  testWidgets(
    'When page opened, share and copy buttons should be available',
    (WidgetTester tester) async {
      final api = ApiResponse.mock();

      await tester.pumpWidget(MaterialApp(home: ApiDetailsPage(api: api)));
      await tester.pumpAndSettle();

      final shareIcon = find.byIcon(Icons.share);
      final copyIcon = find.byIcon(Icons.copy);

      await tester.tap(shareIcon);
      await tester.pumpAndSettle();

      await tester.tap(copyIcon);
      await tester.pumpAndSettle();

      expect(shareIcon, findsOneWidget);
      expect(copyIcon, findsOneWidget);
    },
  );

  testWidgets(
    'When preview mode button pressed in Response tab, json preview type should'
    ' be shuffled',
    (WidgetTester tester) async {
      final api = ApiResponse.mock();

      await tester.pumpWidget(MaterialApp(home: ApiDetailsPage(api: api)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('RESPONSE'));
      await tester.pumpAndSettle();

      ///Initially Tree type preview selected
      expect(find.byType(JsonTree), findsOneWidget);
      expect(find.byType(SelectableText), findsNothing);

      ///On press shuffled with Text type widget
      await tester.tap(find.byType(SizeableTextButton));
      await tester.pumpAndSettle();

      expect(find.byType(JsonTree), findsNothing);
      expect(find.byType(SelectableText), findsOneWidget);
    },
  );

  testWidgets(
    'When preview mode button pressed in Request tab, json preview type should'
    ' be shuffled',
    (WidgetTester tester) async {
      final api = ApiResponse.mock();

      await tester.pumpWidget(MaterialApp(home: ApiDetailsPage(api: api)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('REQUEST'));
      await tester.pumpAndSettle();

      ///Initially Tree type preview selected
      expect(find.byType(JsonTree), findsOneWidget);
      expect(find.byType(SelectableText), findsNothing);

      ///On press shuffled with Text type widget
      await tester.tap(find.byType(SizeableTextButton));
      await tester.pumpAndSettle();

      expect(find.byType(JsonTree), findsNothing);
      expect(find.byType(SelectableText), findsOneWidget);
    },
  );

  testWidgets(
    'When json value is image url image preview button should be visible',
    (WidgetTester tester) async {
      final api = ApiResponse.mock().copyWith(
        body: {'data': 'https://example.png'},
      );

      await tester.pumpWidget(MaterialApp(home: ApiDetailsPage(api: api)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('RESPONSE'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.preview_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'When image preview button is pressed, image preview dialog should open',
    (WidgetTester tester) async {
      final api = ApiResponse.mock().copyWith(
        body: {'data': 'https://example.png'},
      );

      await tester.pumpWidget(MaterialApp(home: ApiDetailsPage(api: api)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('RESPONSE'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.preview_rounded));
      await tester.pumpAndSettle();
    },
  );
}
