import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/widgets/apis_listing_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApisListingItemWidget', () {
    Widget buildTestWidget({
      required void Function(String) onDelete,
      required void Function(String) onChecked,
      required VoidCallback onPressed,
      String baseUrl = 'https://api.example.com',
      DateTime? dateTime,
      String method = 'GET',
      String path = '/users',
      int statusCode = 200,
      bool checked = false,
      bool showDelete = true,
      dynamic request,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          ...Localization.localizationsDelegates,
        ],
        supportedLocales: Localization.supportedLocales,
        home: Scaffold(
          body: ApisListingItemWidget(
            baseUrl: baseUrl,
            dateTime: dateTime ?? DateTime(2024),
            method: method,
            path: path,
            statusCode: statusCode,
            onDelete: onDelete,
            checked: checked,
            onChecked: onChecked,
            showDelete: showDelete,
            onPressed: onPressed,
            request: request,
          ),
        ),
      );
    }

    testWidgets('should display status code', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      expect(find.text('200'), findsOneWidget);
    });

    testWidgets('should display HTTP method', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          method: 'POST',
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      expect(find.text('POST'), findsOneWidget);
    });

    testWidgets('should display path', (WidgetTester tester) async {
      const testPath = '/api/users/123';

      await tester.pumpWidget(
        buildTestWidget(
          path: testPath,
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      expect(find.text(testPath), findsOneWidget);
    });

    testWidgets('should display base URL', (WidgetTester tester) async {
      const testBaseUrl = 'https://test.example.com';

      await tester.pumpWidget(
        buildTestWidget(
          baseUrl: testBaseUrl,
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      expect(find.text(testBaseUrl), findsOneWidget);
    });

    testWidgets('should display N/A when baseUrl is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          baseUrl: '',
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      expect(find.text(Localization.strings['nA']!), findsAtLeastNWidgets(1));
    });

    testWidgets('should display dateTime', (WidgetTester tester) async {
      final testDate = DateTime(2024, 12, 25, 10, 30);

      await tester.pumpWidget(
        buildTestWidget(
          dateTime: testDate,
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      expect(find.text(testDate.toString()), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped',
        (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        buildTestWidget(
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () => pressed = true,
          request: <String, dynamic>{},
        ),
      );

      await tester.tap(find.byKey(const ValueKey('api_listing_item_widget')));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('should call onDelete when delete button is tapped',
        (WidgetTester tester) async {
      String? deletedId;
      final testDate = DateTime(2024);

      await tester.pumpWidget(
        buildTestWidget(
          dateTime: testDate,
          onDelete: (id) => deletedId = id,
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      await tester.tap(find.text(Localization.strings['delete']!));
      await tester.pump();

      expect(deletedId, testDate.toString());
    });

    testWidgets('should call onChecked when checkbox is tapped',
        (WidgetTester tester) async {
      String? checkedId;
      final testDate = DateTime(2024);

      await tester.pumpWidget(
        buildTestWidget(
          dateTime: testDate,
          onDelete: (_) {},
          onChecked: (id) => checkedId = id,
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(checkedId, testDate.toString());
    });

    testWidgets('should show delete button when showDelete is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      expect(find.text(Localization.strings['delete']!), findsOneWidget);
    });

    testWidgets('should hide delete button when showDelete is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          showDelete: false,
          request: <String, dynamic>{},
        ),
      );

      expect(find.text(Localization.strings['delete']!), findsNothing);
    });

    testWidgets('should show checked checkbox when checked is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          checked: true,
          request: <String, dynamic>{},
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('should show unchecked checkbox when checked is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);
    });

    testWidgets('should display request data when not empty',
        (WidgetTester tester) async {
      const requestData = '{"name": "John"}';

      await tester.pumpWidget(
        buildTestWidget(
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: requestData,
        ),
      );

      expect(find.text(requestData), findsOneWidget);
    });

    testWidgets('should display N/A when request is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: '',
        ),
      );

      expect(find.text(Localization.strings['nA']!), findsAtLeastNWidgets(1));
    });

    testWidgets('should display all method types correctly',
        (WidgetTester tester) async {
      for (final method in ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']) {
        await tester.pumpWidget(
          buildTestWidget(
            method: method,
            onDelete: (_) {},
            onChecked: (_) {},
            onPressed: () {},
            request: <String, dynamic>{},
          ),
        );

        expect(find.text(method), findsOneWidget);
      }
    });

    testWidgets('should handle different status codes',
        (WidgetTester tester) async {
      for (final statusCode in [200, 201, 400, 404, 500]) {
        await tester.pumpWidget(
          buildTestWidget(
            statusCode: statusCode,
            onDelete: (_) {},
            onChecked: (_) {},
            onPressed: () {},
            request: <String, dynamic>{},
          ),
        );

        expect(find.text(statusCode.toString()), findsOneWidget);
      }
    });

    testWidgets('should have two Chip widgets (status and method)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          onDelete: (_) {},
          onChecked: (_) {},
          onPressed: () {},
          request: <String, dynamic>{},
        ),
      );

      expect(find.byType(Chip), findsNWidgets(2));
    });
  });
}
