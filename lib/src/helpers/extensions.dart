import 'package:flutter/material.dart';

///Checks whether a number is zero or not
extension IsNotZeroExtension on num {
  ///Checks whether a number is zero or not
  bool get isNotZero => this != 0;
}

///Gets theme with respect to given context
extension ThemeExtension on BuildContext {
  ///Theme of the context
  ThemeData get theme => Theme.of(this);

  ///Text theme of the context
  TextTheme get textTheme => Theme.of(this).textTheme;
}

///Gets navigator with respect to given context
extension NavigatorExtension on BuildContext {
  ///Navigator of the  context
  NavigatorState get navigator => Navigator.of(this);
}

///TextStyle extensions
extension TextStyleExtension on TextStyle {
  ///Make a text bold
  TextStyle toBold() => copyWith(fontWeight: FontWeight.bold);

  ///Color a text
  TextStyle withColor(Color? color) => copyWith(color: color);

  ///Change font size of  a text
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

///String extensions
extension StringExtension on String {
  ///Checks if a url is image
  bool isImageUrl() {
    final imageUrlRegex = RegExp(
      r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)',
    );
    return imageUrlRegex.hasMatch(this);
  }
}
