import 'package:chucker_flutter/src/view/helper/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

part 'localization.ur.dart';
part 'localization.en.dart';

///Helps implementing localization in chucker ui
class Localization {
  ///Supported locales
  static const supportedLocales = [Locale('en'), Locale('ur')];

  ///Localization delegates for maintaining localized ui behaviour
  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  ///Current locale. It can be changed from settings page
  static Locale currentLocale = supportedLocales.first;

  ///Text direction based on current locale settings
  static TextDirection textDirection = TextDirection.ltr;

  ///Localized strings
  static Map<String, String> strings = _en;

  ///Return all translation maps
  ///
  ///This must be in exact order as of [supportedLocales] otherwise tests may
  ///fail
  static List<Map<String, String>> stringMaps = [_en, _ur];

  ///Updates chucker language
  static void updateLocalization(Language language) {
    switch (language) {
      case Language.urdu:
        strings = _ur;
        break;
      case Language.english:
        strings = _en;
        break;
    }
    currentLocale = supportedLocales[language.index];
    textDirection = _textDirection(language);
  }

  static TextDirection _textDirection(Language language) {
    switch (language) {
      case Language.english:
        return TextDirection.ltr;
      case Language.urdu:
        return TextDirection.rtl;
    }
  }
}
