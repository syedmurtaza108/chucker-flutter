import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/api_detail_page.dart';
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
}
