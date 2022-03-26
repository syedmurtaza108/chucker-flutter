import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/helper/languages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('There should be exact same number of strings in each localization', () {
    final stringsCount = List<int>.empty(growable: true);

    for (final language in Language.values) {
      Localization.updateLocalization(language);
      stringsCount.add(Localization.strings.length);
    }

    expect(
      stringsCount.firstWhere(
        (e) => e != stringsCount.first,
        orElse: () => -1,
      ),
      -1,
    );
  });

  test('There should be exact same names for keys in each localization', () {
    final keysList = List<List<String>>.empty(growable: true);

    for (final language in Language.values) {
      Localization.updateLocalization(language);
      keysList.add(Localization.strings.keys.toList());
    }

    expect(
      keysList
          .firstWhere(
            (e) => !listEquals(e, keysList.first),
            orElse: List.empty,
          )
          .length,
      0,
    );
  });

  test('There should be no translation duplicated', () {
    var isDuplicate = false;

    for (final language in Language.values) {
      final translations = List<String>.empty(growable: true);

      Localization.updateLocalization(language);

      for (final translation in Localization.strings.values) {
        if (translations.contains(translation)) {
          isDuplicate = true;
          break;
        }
        translations.add(translation);
      }
      if (isDuplicate) {
        break;
      }
    }

    expect(isDuplicate, false);
  });

  test(
    'There should be exact same number of translation maps and locales',
    () {
      expect(
        Localization.supportedLocales.length,
        Localization.stringMaps.length,
      );
    },
  );

  test(
    '.strings should return the correct translations based on locale',
    () {
      var isCorrectMap = true;
      for (var i = 0; i < Language.values.length; i++) {
        Localization.updateLocalization(Language.values[i]);
        if (Localization.strings != Localization.stringMaps[i]) {
          isCorrectMap = false;
          break;
        }
      }

      expect(isCorrectMap, true);
    },
  );

  test(
    'Current locale should be updated',
    () {
      var isCorrectLocale = true;
      for (var i = 0; i < Language.values.length; i++) {
        Localization.updateLocalization(Language.values[i]);
        if (Localization.currentLocale.languageCode !=
            Localization.supportedLocales[i].languageCode) {
          isCorrectLocale = false;
          break;
        }
      }

      expect(isCorrectLocale, true);
    },
  );
}
