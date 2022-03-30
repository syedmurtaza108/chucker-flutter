import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/chucker_page.dart';
import 'package:chucker_flutter/src/view/tabs/apis_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'On init page should load all requests from shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance();

      final successReq = ApiResponse.mock().copyWith(statusCode: 200);
      final failReq = ApiResponse.mock().copyWith(statusCode: 400);
      final successReq2 = ApiResponse.mock().copyWith(statusCode: 200);

      await sharedPreferencesManager.addApiResponse(successReq);
      await sharedPreferencesManager.addApiResponse(failReq);
      await sharedPreferencesManager.addApiResponse(successReq2);

      await tester.pumpWidget(const MaterialApp(home: ChuckerPage()));
      await tester.pumpAndSettle();

      final tabBarView = find
          .byKey(const Key('apis_tab_bar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      final successTab = tabBarView.children[0] as ApisListingTabView;
      final failureTab = tabBarView.children[1] as ApisListingTabView;

      //Total requests = 3
      expect(successTab.apis.length + failureTab.apis.length, 3);
    },
  );
  testWidgets(
    'Success tab should load all success requests from shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance();

      final successReq = ApiResponse.mock().copyWith(statusCode: 200);
      final failReq = ApiResponse.mock().copyWith(statusCode: 400);

      await sharedPreferencesManager.addApiResponse(successReq);
      await sharedPreferencesManager.addApiResponse(failReq);

      //Total requests = 2

      await tester.pumpWidget(const MaterialApp(home: ChuckerPage()));
      await tester.pumpAndSettle();

      final tabBarView = find
          .byKey(const Key('apis_tab_bar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      final successTab = tabBarView.children.first as ApisListingTabView;

      //Success Request = 1
      expect(successTab.apis.length, 1);
    },
  );

  testWidgets(
    'Fail requests tab should load all failed requests from shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance();

      final successReq = ApiResponse.mock().copyWith(statusCode: 200);
      final failReq = ApiResponse.mock().copyWith(statusCode: 400);

      await sharedPreferencesManager.addApiResponse(successReq);
      await sharedPreferencesManager.addApiResponse(failReq);

      //Total requests = 2

      await tester.pumpWidget(const MaterialApp(home: ChuckerPage()));
      await tester.pumpAndSettle();

      final tabBarView = find
          .byKey(const Key('apis_tab_bar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      final failureTab = tabBarView.children[1] as ApisListingTabView;

      //Success Request = 1
      expect(failureTab.apis.length, 1);
    },
  );

  testWidgets(
    'On click on select all check all requests should be selected',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance();

      final successReq = ApiResponse.mock().copyWith(statusCode: 200);

      await sharedPreferencesManager.addApiResponse(successReq);

      await tester.pumpWidget(const MaterialApp(home: ChuckerPage()));
      await tester.pumpAndSettle();

      var tabBarView = find
          .byKey(const Key('apis_tab_bar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      final successTab = tabBarView.children[0] as ApisListingTabView;

      final totalChecked = successTab.apis.where((e) => e.checked).length;

      //Since no item is selected
      expect(totalChecked, 0);

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      tabBarView = find
          .byKey(const Key('apis_tab_bar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      final successTab1 = tabBarView.children[0] as ApisListingTabView;

      final totalChecked1 = successTab1.apis.where((e) => e.checked).length;

      expect(totalChecked1, 1);
    },
  );
}
