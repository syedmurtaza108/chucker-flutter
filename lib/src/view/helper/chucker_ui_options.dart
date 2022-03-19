import 'package:flutter/material.dart';

///[ChuckerUiOptions] gives the options to change user experience of
///`chucker_flutter` notification and screens
class ChuckerUiOptions{
  ///[duration] is the amount of time of making notification visible on screen.
  static Duration duration = const Duration(seconds: 2);

  ///[positionTop] is the top position of chucker notification
  static double positionTop = 0;

  ///[positionBottom] is the bottom position of chucker notification
  static double positionBottom = 0;

  ///[positionRight] is the right position of chucker notification
  static double positionRight = 0;

  ///[positionLeft] is the left position of chucker notification
  static double positionLeft = 0;

  ///[notificationAlignment] align the notification with [Alignment]
  /// To use it [positionTop], [positionBottom], [positionRight], [positionLeft]
  /// must be 0.
  /// ***default value is Alignment.bottomCenter***
  static AlignmentGeometry notificationAlignment = Alignment.bottomCenter;
}
