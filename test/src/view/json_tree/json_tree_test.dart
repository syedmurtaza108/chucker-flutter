import 'package:chucker_flutter/src/view/json_tree/json_tree.dart';
import 'package:chucker_flutter/src/view/widgets/sizeable_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  bool favoritePersonalitiesButton(Element element) {
    return (element.widget as SizeableTextButton).text ==
        'favoritePersonalities';
  }

  String toText(Element element) {
    return (element.widget as Text).data ?? '';
  }

  String toKeyFormat(String key) {
    return '$key:';
  }

  testWidgets(
    'JsonTree should be able to parse single json object',
    (WidgetTester tester) async {
      ///⚠️ DON'T CHANGE CONTENT OTHERWISE TEST MAY FAIL
      const json = {
        'id': 1,
        'name': 'Syed Murtaza',
        'weight': 56.8,
        'isInPakistan': true,
        'favoritePersonalities': ['Allama Iqbal', 'Muhammad Ali Jinnah'],
      };

      await tester.pumpWidget(const MaterialApp(home: JsonTree(json: json)));

      //favoritePersonalities is expandable therefore it needs to be pressed
      //on to expand
      final personalitiesButton = find
          .byType(SizeableTextButton)
          .evaluate()
          .where(favoritePersonalitiesButton)
          .first
          .widget;

      //Expanded
      await tester.tap(find.byWidget(personalitiesButton));
      await tester.pumpAndSettle();

      final finder = find.byType(Text);
      final elements = finder.evaluate().toList();

      final keys = json.keys;
      final values = json.values;

      expect(toText(elements[0]), toKeyFormat(keys.elementAt(0)));
      expect(toText(elements[1]), values.elementAt(0).toString());
      expect(toText(elements[3]), toKeyFormat(keys.elementAt(1)));
      expect(toText(elements[4]), '"${values.elementAt(1)}"');
      expect(toText(elements[6]), toKeyFormat(keys.elementAt(2)));
      expect(toText(elements[7]), values.elementAt(2).toString());
      expect(toText(elements[9]), toKeyFormat(keys.elementAt(3)));
      expect(toText(elements[10]), values.elementAt(3).toString());
      expect(toText(elements[14]), toKeyFormat('[0]'));
      expect(
        toText(elements[15]),
        '"${(values.last as List).first}"',
      );
      expect(toText(elements[17]), toKeyFormat('[1]'));
      expect(
        toText(elements[18]),
        '"${(values.last as List).elementAt(1)}"',
      );
    },
  );

  testWidgets(
    'JsonTree should be able to parse json array',
    (WidgetTester tester) async {
      ///⚠️ DON'T CHANGE CONTENT OTHERWISE TEST MAY FAIL
      const json = [
        {
          'id': 1,
          'name': 'Syed Murtaza',
        },
        {
          'id': 2,
          'name': 'Syed Murtaza',
        }
      ];

      await tester.pumpWidget(
        MaterialApp(home: JsonTree(json: json, key: UniqueKey())),
      );

      //Need to expand both objects
      final buttons = find.byType(SizeableTextButton).evaluate();

      //Expanded
      await tester.tap(find.byWidget(buttons.first.widget));
      await tester.pumpAndSettle();
      await tester.tap(find.byWidget(buttons.last.widget));
      await tester.pumpAndSettle();

      final finder = find.byType(Text);
      final elements = finder.evaluate().toList();

      //Parsing object 1
      final object1Keys = json[0].keys;
      final object1values = json[0].values;

      expect(toText(elements[0]), toKeyFormat('[0]'));
      expect(toText(elements[2]), toKeyFormat(object1Keys.elementAt(0)));
      expect(toText(elements[3]), object1values.elementAt(0).toString());
      expect(toText(elements[5]), toKeyFormat(object1Keys.elementAt(1)));
      expect(toText(elements[6]), '"${object1values.elementAt(1)}"');

      //Parsing object 2
      final object2Keys = json[1].keys;
      final object2values = json[1].values;

      expect(toText(elements[8]), toKeyFormat('[1]'));
      expect(toText(elements[10]), toKeyFormat(object2Keys.elementAt(0)));
      expect(toText(elements[11]), object2values.elementAt(0).toString());
      expect(toText(elements[13]), toKeyFormat(object2Keys.elementAt(1)));
      expect(toText(elements[14]), '"${object2values.elementAt(1)}"');
    },
  );

  testWidgets(
    'JsonTree should show Empty List when a value of array key is empty',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: JsonTree(json: {'id': <dynamic>[]})),
      );
      expect(find.text('Empty List'), findsOneWidget);
    },
  );

  testWidgets(
    'JsonTree should show N/A when a value of key is null',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: JsonTree(json: {'id': null})),
      );
      expect(find.text('N/A'), findsOneWidget);
    },
  );

  testWidgets(
    'JsonTree should show copy success icon when copy button is pressed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: JsonTree(json: {'id': 1})),
      );

      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Copy'), findsNothing);
    },
  );

  testWidgets(
    'JsonTree should expand value of subkey when pressed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: JsonTree(
            json: {
              'data': {'id': 1},
            },
          ),
        ),
      );

      await tester.tap(find.text('data'));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    },
  );
}
