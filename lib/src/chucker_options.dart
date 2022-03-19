import 'package:chucker_flutter/src/view/chucker_page.dart';
import 'package:chucker_flutter/src/view/helper/method_enums.dart';
import 'package:flutter/material.dart';

///[ChuckerOptions] gives the options to change user experience of
///`chucker_flutter` notification and screens
class ChuckerOptions {
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

  ///[apiThresholds] is the total number of api requests that would be saved
  ///on user's device. Default value is `100`
  ///
  ///***Be aware of setting it. Large number of api requests may consume huge
  ///amount of memory on user's device.***
  static int apiThresholds = 100;

  ///[httpMethod] default http method filter in apis listing screen 
  ///[ChuckerPage]. Its default value is [HttpMethod.none] which means that 
  ///no filter is applied.
  static HttpMethod httpMethod = HttpMethod.none;
}
