import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('status phrases should not be duplicated', () {
    var isDuplicate = false;

    final phrases = List<String>.empty(growable: true);
    for (final phrase in statusCodes.values) {
      if (phrases.contains(phrase)) {
        isDuplicate = true;
        break;
      }
      phrases.add(phrase);
    }

    expect(isDuplicate, false);
  });
}
