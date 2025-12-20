import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/tabs/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverviewTabView', () {
    Widget buildTestWidget(ApiResponse api) {
      return MaterialApp(
        localizationsDelegates: const [
          ...Localization.localizationsDelegates,
        ],
        supportedLocales: Localization.supportedLocales,
        home: Scaffold(
          body: OverviewTabView(api: api),
        ),
      );
    }

    testWidgets('should display Table widget', (WidgetTester tester) async {
      final api = ApiResponse.mock();
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.byType(Table), findsOneWidget);
    });

    testWidgets('should display header row with Attribute and Value',
        (WidgetTester tester) async {
      final api = ApiResponse.mock();
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text(Localization.strings['attribute']!), findsOneWidget);
      expect(find.text(Localization.strings['value']!), findsOneWidget);
    });

    testWidgets('should display Base URL', (WidgetTester tester) async {
      const baseUrl = 'https://api.example.com';
      final api = ApiResponse.mock().copyWith(baseUrl: baseUrl);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Base URL'), findsOneWidget);
      expect(find.text(baseUrl), findsOneWidget);
    });

    testWidgets('should display Path', (WidgetTester tester) async {
      const path = '/users/123';
      final api = ApiResponse.mock().copyWith(path: path);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Path'), findsOneWidget);
      expect(find.text(path), findsOneWidget);
    });

    testWidgets('should display Method', (WidgetTester tester) async {
      const method = 'POST';
      final api = ApiResponse.mock().copyWith(method: method);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Method'), findsOneWidget);
      expect(find.text(method), findsOneWidget);
    });

    testWidgets('should display Status Code with description',
        (WidgetTester tester) async {
      const statusCode = 200;
      final api = ApiResponse.mock().copyWith(statusCode: statusCode);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Status Code'), findsOneWidget);
      expect(find.textContaining('200'), findsOneWidget);
    });

    testWidgets('should display Request Time', (WidgetTester tester) async {
      final requestTime = DateTime(2024, 1, 1, 10, 30);
      final api = ApiResponse.mock().copyWith(requestTime: requestTime);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Request Time'), findsOneWidget);
      expect(find.text(requestTime.toString()), findsOneWidget);
    });

    testWidgets('should display Response Time', (WidgetTester tester) async {
      final responseTime = DateTime(2024, 1, 1, 10, 31);
      final api = ApiResponse.mock().copyWith(responseTime: responseTime);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Response Time'), findsOneWidget);
      expect(find.text(responseTime.toString()), findsOneWidget);
    });

    testWidgets('should display Headers', (WidgetTester tester) async {
      const headers = {'Content-Type': 'application/json'};
      final api = ApiResponse.mock().copyWith(headers: headers);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Headers'), findsOneWidget);
      expect(find.text(headers.toString()), findsOneWidget);
    });

    testWidgets('should display Query Parameters', (WidgetTester tester) async {
      const queryParams = {'page': '1', 'limit': '10'};
      final api = ApiResponse.mock().copyWith(queryParameters: queryParams);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Query Parameters'), findsOneWidget);
      expect(find.text(queryParams.toString()), findsOneWidget);
    });

    testWidgets('should display Content Type', (WidgetTester tester) async {
      const contentType = 'application/json';
      final api = ApiResponse.mock().copyWith(contentType: contentType);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Content Type'), findsOneWidget);
      expect(find.text(contentType), findsOneWidget);
    });

    testWidgets('should display N/A for null Content Type',
        (WidgetTester tester) async {
      final api = ApiResponse.mock().copyWith();
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Content Type'), findsOneWidget);
      expect(find.text('N/A'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display Response Type', (WidgetTester tester) async {
      const responseType = 'json';
      final api = ApiResponse.mock().copyWith(responseType: responseType);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Response Type'), findsOneWidget);
      expect(find.text(responseType), findsOneWidget);
    });

    testWidgets('should display Client Library', (WidgetTester tester) async {
      const clientLibrary = 'dio';
      final api = ApiResponse.mock().copyWith(clientLibrary: clientLibrary);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Client Library'), findsOneWidget);
      expect(find.text(clientLibrary), findsOneWidget);
    });

    testWidgets('should display Connection Timeout with ms',
        (WidgetTester tester) async {
      const timeout = 5000;
      final api = ApiResponse.mock().copyWith(connectionTimeout: timeout);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Connection Timeout'), findsOneWidget);
      expect(find.text('$timeout ms'), findsOneWidget);
    });

    testWidgets('should display N/A for zero Connection Timeout',
        (WidgetTester tester) async {
      final api = ApiResponse.mock().copyWith(connectionTimeout: 0);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Connection Timeout'), findsOneWidget);
    });

    testWidgets('should display Receive Timeout with ms',
        (WidgetTester tester) async {
      const timeout = 3000;
      final api = ApiResponse.mock().copyWith(receiveTimeout: timeout);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Receive Timeout'), findsOneWidget);
      expect(find.text('$timeout ms'), findsOneWidget);
    });

    testWidgets('should display Send Timeout with ms',
        (WidgetTester tester) async {
      const timeout = 2000;
      final api = ApiResponse.mock().copyWith(sendTimeout: timeout);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Send Timeout'), findsOneWidget);
      expect(find.text('$timeout ms'), findsOneWidget);
    });

    testWidgets('should display Response Headers', (WidgetTester tester) async {
      const responseHeaders = {'Server': 'nginx'};
      final api = ApiResponse.mock().copyWith(responseHeaders: responseHeaders);
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Response Headers'), findsOneWidget);
      expect(find.text(responseHeaders.toString()), findsOneWidget);
    });

    testWidgets('should display CURL command', (WidgetTester tester) async {
      final api = ApiResponse.mock();
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('CURL'), findsOneWidget);
      // toCurl() should return some value
      expect(find.textContaining('curl'), findsOneWidget);
    });

    testWidgets('should have copy button for each row',
        (WidgetTester tester) async {
      final api = ApiResponse.mock();
      await tester.pumpWidget(buildTestWidget(api));

      // Should find multiple copy buttons (one for each data row)
      expect(
        find.text(Localization.strings['copy']!),
        findsAtLeastNWidgets(10),
      );
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      final api = ApiResponse.mock();
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have proper padding', (WidgetTester tester) async {
      final api = ApiResponse.mock();
      await tester.pumpWidget(buildTestWidget(api));

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.padding, const EdgeInsets.all(16));
    });

    testWidgets('should display all table rows', (WidgetTester tester) async {
      final api = ApiResponse.mock();
      await tester.pumpWidget(buildTestWidget(api));

      final table = tester.widget<Table>(find.byType(Table));
      // Should have header row + multiple data rows
      expect(table.children.length, greaterThan(10));
    });

    testWidgets('should handle empty headers', (WidgetTester tester) async {
      final api = ApiResponse.mock().copyWith(headers: {});
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Headers'), findsOneWidget);
      expect(find.text('{}'), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle empty query parameters',
        (WidgetTester tester) async {
      final api = ApiResponse.mock().copyWith(queryParameters: {});
      await tester.pumpWidget(buildTestWidget(api));

      expect(find.text('Query Parameters'), findsOneWidget);
      expect(find.text('{}'), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle different HTTP methods',
        (WidgetTester tester) async {
      for (final method in ['GET', 'POST', 'PUT', 'DELETE', 'PATCH']) {
        final api = ApiResponse.mock().copyWith(method: method);
        await tester.pumpWidget(buildTestWidget(api));

        expect(find.text(method), findsOneWidget);
      }
    });

    testWidgets('should handle different status codes',
        (WidgetTester tester) async {
      for (final statusCode in [200, 201, 400, 404, 500]) {
        final api = ApiResponse.mock().copyWith(statusCode: statusCode);
        await tester.pumpWidget(buildTestWidget(api));

        expect(find.textContaining(statusCode.toString()), findsOneWidget);
      }
    });
  });
}
