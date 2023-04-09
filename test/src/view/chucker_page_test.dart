import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/chucker_page.dart';
import 'package:chucker_flutter/src/view/tabs/apis_listing.dart';
import 'package:chucker_flutter/src/view/widgets/apis_listing_item.dart';
import 'package:chucker_flutter/src/view/widgets/menu_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'On init page should load all requests from shared preferences',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance(
        initData: false,
      );

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

      final sharedPreferencesManager = SharedPreferencesManager.getInstance(
        initData: false,
      );

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

      final sharedPreferencesManager = SharedPreferencesManager.getInstance(
        initData: false,
      );

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
    'When items are not selected, on click on select all '
    'requests should be selected',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance(
        initData: false,
      );

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

  testWidgets(
    'When items are selected, on click on select all '
    'requests should be deselected',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance(
        initData: false,
      );

      final successReq = ApiResponse.mock().copyWith(
        statusCode: 200,
        checked: true,
      );

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

      expect(totalChecked, 1);

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      tabBarView = find
          .byKey(const Key('apis_tab_bar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      final successTab1 = tabBarView.children[0] as ApisListingTabView;

      final totalChecked1 = successTab1.apis.where((e) => e.checked).length;

      expect(totalChecked1, 0);
    },
  );

  testWidgets(
    'App bar should have menu item on top with delete and settings buttons',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance(
        initData: false,
      );
      final successReq = ApiResponse.mock();

      await sharedPreferencesManager.addApiResponse(successReq);
      await tester.pumpWidget(const MaterialApp(home: ChuckerPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      //Open menu
      await tester.tap(find.byType(MenuButtons));
      await tester.pumpAndSettle();

      //Open settings page
      await tester.tap(find.byKey(const ValueKey('menu_settings')));
      await tester.pumpAndSettle();

      //Open menu again
      await tester.tap(find.byType(MenuButtons));
      await tester.pumpAndSettle();

      //Open delete dialog
      await tester.tap(find.byKey(const ValueKey('menu_delete')));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'When api lists are not empty, on click on item '
    'user should be redirected to details page',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance(
        initData: false,
      );

      final successReq = ApiResponse.mock();

      await sharedPreferencesManager.addApiResponse(successReq);

      await tester.pumpWidget(const MaterialApp(home: ChuckerPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ApisListingItemWidget).first);
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'On click on Show Search button search field should be visible ',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ChuckerPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Search'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const ValueKey('search_field')), findsOneWidget);
    },
  );

  testWidgets(
    'On typing on search field, filtered item should be returned',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance(
        initData: false,
      );

      final successReq = ApiResponse.mock().copyWith(baseUrl: 'hello');
      final successReq2 = ApiResponse.mock().copyWith(baseUrl: 'hi');

      await sharedPreferencesManager.addApiResponse(successReq);
      await sharedPreferencesManager.addApiResponse(successReq2);

      await tester.pumpWidget(const MaterialApp(home: ChuckerPage()));
      await tester.pumpAndSettle();

      var tabBarView = find
          .byKey(const Key('apis_tab_bar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      var successTab = tabBarView.children[0] as ApisListingTabView;

      expect(successTab.apis.length, 2);

      await tester.tap(find.text('Show Search'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(
        find.byKey(const ValueKey('search_field')),
        'hi',
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      tabBarView = find
          .byKey(const Key('apis_tab_bar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      successTab = tabBarView.children[0] as ApisListingTabView;

      expect(successTab.apis.length, 1);
    },
  );

  testWidgets(
    'On click on delete button, an api detail should be deleted',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final sharedPreferencesManager = SharedPreferencesManager.getInstance(
        initData: false,
      );

      final api = ApiResponse.mock();

      await sharedPreferencesManager.addApiResponse(api);

      await tester.pumpWidget(const MaterialApp(home: ChuckerPage()));
      await tester.pumpAndSettle();

      final tabBarView = find
          .byKey(const Key('apis_tab_bar_view'))
          .evaluate()
          .first
          .widget as TabBarView;

      final successTab = tabBarView.children[0] as ApisListingTabView;

      expect(successTab.apis.length, 1);

      await tester.tap(find.text('DELETE').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('YES'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect((await sharedPreferencesManager.getAllApiResponses()).length, 0);
    },
  );
}
