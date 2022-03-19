import 'package:flutter/material.dart';

///Checks whether a number is zero or not
extension IsNotZero on num {
  ///Checks whether a number is zero or not
  bool get isNotZero => this > 0;
}

///Gets theme with respect to given context
extension ThemeExtension on BuildContext {
  ///Theme of the context
  ThemeData get theme => Theme.of(this);
}
