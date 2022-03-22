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
}

///Gets navigator with respect to given context
extension NavigatorExtension on BuildContext {
  ///Navigator of the  context
  NavigatorState get navigator => Navigator.of(this);
}
