import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/helper/http_methods.dart';
import 'package:chucker_flutter/src/view/widgets/http_methods_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpMethodsMenu', () {
    Widget buildTestWidget({
      required HttpMethod httpMethod,
      required void Function(HttpMethod) onFilter,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          ...Localization.localizationsDelegates,
        ],
        supportedLocales: Localization.supportedLocales,
        home: Scaffold(
          body: HttpMethodsMenu(
            httpMethod: httpMethod,
            onFilter: onFilter,
          ),
        ),
      );
    }

    testWidgets('should display Http Method label',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          httpMethod: HttpMethod.get,
          onFilter: (_) {},
        ),
      );

      expect(find.text('Http Method: '), findsOneWidget);
    });

    testWidgets('should display current method in chip',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          httpMethod: HttpMethod.get,
          onFilter: (_) {},
        ),
      );

      expect(find.text('GET'), findsOneWidget);
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('should display all methods when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          httpMethod: HttpMethod.get,
          onFilter: (_) {},
        ),
      );

      await tester.tap(find.byType(HttpMethodsMenu));
      await tester.pumpAndSettle();

      expect(find.text(Localization.strings['all']!), findsOneWidget);
      expect(find.text('GET'), findsNWidgets(2)); // One in chip, one in menu
      expect(find.text('POST'), findsOneWidget);
      expect(find.text('PUT'), findsOneWidget);
      expect(find.text('PATCH'), findsOneWidget);
      expect(find.text('DELETE'), findsOneWidget);
    });

    testWidgets('should call onFilter when method is selected',
        (WidgetTester tester) async {
      HttpMethod? selectedMethod;

      await tester.pumpWidget(
        buildTestWidget(
          httpMethod: HttpMethod.get,
          onFilter: (method) => selectedMethod = method,
        ),
      );

      await tester.tap(find.byType(HttpMethodsMenu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('POST'));
      await tester.pumpAndSettle();

      expect(selectedMethod, HttpMethod.post);
    });

    testWidgets('should show checked icon for current method',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          httpMethod: HttpMethod.post,
          onFilter: (_) {},
        ),
      );

      await tester.tap(find.byType(HttpMethodsMenu));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_off), findsNWidgets(5));
    });

    testWidgets('should display "All" for HttpMethod.none',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          httpMethod: HttpMethod.none,
          onFilter: (_) {},
        ),
      );

      expect(find.text(Localization.strings['all']!), findsOneWidget);
    });

    testWidgets('should handle selection of HttpMethod.none',
        (WidgetTester tester) async {
      HttpMethod? selectedMethod;

      await tester.pumpWidget(
        buildTestWidget(
          httpMethod: HttpMethod.get,
          onFilter: (method) => selectedMethod = method,
        ),
      );

      await tester.tap(find.byType(HttpMethodsMenu));
      await tester.pumpAndSettle();

      await tester.tap(find.text(Localization.strings['all']!));
      await tester.pumpAndSettle();

      expect(selectedMethod, HttpMethod.none);
    });

    testWidgets('should display correct method for each HttpMethod enum',
        (WidgetTester tester) async {
      final methodMap = {
        HttpMethod.get: 'GET',
        HttpMethod.post: 'POST',
        HttpMethod.put: 'PUT',
        HttpMethod.patch: 'PATCH',
        HttpMethod.delete: 'DELETE',
      };

      for (final entry in methodMap.entries) {
        await tester.pumpWidget(
          buildTestWidget(
            httpMethod: entry.key,
            onFilter: (_) {},
          ),
        );

        expect(find.text(entry.value), findsOneWidget);
      }
    });

    testWidgets('should apply border radius to container',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          httpMethod: HttpMethod.get,
          onFilter: (_) {},
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(HttpMethodsMenu),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('should handle multiple selections',
        (WidgetTester tester) async {
      final selectedMethods = <HttpMethod>[];

      await tester.pumpWidget(
        buildTestWidget(
          httpMethod: HttpMethod.get,
          onFilter: selectedMethods.add,
        ),
      );

      // Select POST
      await tester.tap(find.byType(HttpMethodsMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('POST'));
      await tester.pumpAndSettle();

      // Select PUT
      await tester.tap(find.byType(HttpMethodsMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('PUT'));
      await tester.pumpAndSettle();

      expect(selectedMethods.length, 2);
      expect(selectedMethods[0], HttpMethod.post);
      expect(selectedMethods[1], HttpMethod.put);
    });
  });
}
