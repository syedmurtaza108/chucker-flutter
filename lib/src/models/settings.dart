import 'package:chucker_flutter/src/view/helper/method_enums.dart';
import 'package:flutter/material.dart';

///[Settings] is the model to save and retrieve settings from shared preferences
class Settings {
  ///[Settings] is the model to save and retrieve from shared preferences
  Settings({
    required this.duration,
    required this.notificationAlignment,
    required this.apiThresholds,
    required this.httpMethod,
    required this.showNotification,
    required this.showDeleteConfirmDialog,
    required this.showRequestsStats,
    required this.positionBottom,
    required this.positionLeft,
    required this.positionRight,
    required this.positionTop,
  });

  ///Convert json to [Settings]
  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        duration: Duration(milliseconds: json['duration'] as int),
        notificationAlignment: Alignment(
          (json['notificationAlignment'] as List<double>)[0],
          (json['notificationAlignment'] as List<double>)[1],
        ),
        apiThresholds: json['apiThresholds'] as int,
        httpMethod: HttpMethod.values[json['httpMethod'] as int],
        showNotification: json['showNotification'] as bool,
        showDeleteConfirmDialog: json['showDeleteConfirmDialog'] as bool,
        showRequestsStats: json['showRequestsStats'] as bool,
        positionBottom: json['positionBottom'] as double,
        positionLeft: json['positionLeft'] as double,
        positionRight: json['positionRight'] as double,
        positionTop: json['positionTop'] as double,
      );

  ///Default object containing the default values for chucker settings
  factory Settings.defaultObject() => Settings(
        duration: const Duration(seconds: 2),
        notificationAlignment: Alignment.bottomCenter,
        apiThresholds: 100,
        httpMethod: HttpMethod.none,
        showNotification: true,
        showDeleteConfirmDialog: true,
        showRequestsStats: true,
        positionBottom: 0,
        positionLeft: 0,
        positionRight: 0,
        positionTop: 0,
      );

  ///[duration] is the amount of time of making notification visible on screen.
  final Duration duration;

  ///[positionTop] is the top position of chucker notification
  final double positionTop;

  ///[positionBottom] is the bottom position of chucker notification
  final double positionBottom;

  ///[positionRight] is the right position of chucker notification
  final double positionRight;

  ///[positionLeft] is the left position of chucker notification
  final double positionLeft;

  ///[notificationAlignment] align the notification with [Alignment]
  /// To use it [positionTop], [positionBottom], [positionRight], [positionLeft]
  /// must be 0.
  /// Its default value is Alignment.bottomCenter
  final Alignment notificationAlignment;

  ///[apiThresholds] is the total number of api requests that would be saved
  ///on user's device. Default value is `100`
  ///
  ///***Be aware of setting it. Large number of api requests may consume huge
  ///amount of memory on user's device.***
  final int apiThresholds;

  ///[httpMethod] default http method filter in apis listing screen
  ///Chucker Page. Its default value is [HttpMethod.none] which means that
  ///no filter is applied.
  final HttpMethod httpMethod;

  ///[showRequestsStats] decides whether to show apis requests summary at the
  ///top of api requests listing screen. Its default value is `true`
  final bool showRequestsStats;

  ///[showNotification] decides whether to show notification when a request
  ///is succeeded or failed
  final bool showNotification;

  ///[showDeleteConfirmDialog] decides whether to show a confirmation dialog
  ///before deleting a record. Its default value is `true`
  final bool showDeleteConfirmDialog;

  ///Convert [Settings] to json.
  Map<String, dynamic> toJson() {
    return {
      'apiThresholds': apiThresholds,
      'duration': duration.inMicroseconds,
      'httpMethod': httpMethod.index,
      'notificationAlignment': [
        notificationAlignment.x,
        notificationAlignment.y
      ],
      'positionBottom': positionBottom,
      'positionLeft': positionLeft,
      'positionRight': positionRight,
      'positionTop': positionTop,
      'showDeleteConfirmDialog': showDeleteConfirmDialog,
      'showNotification': showNotification,
      'showRequestsStats': showRequestsStats,
    };
  }

  ///Copies current data and returns new object
  Settings copyWith({
    Duration? duration,
    double? positionTop,
    double? positionBottom,
    double? positionRight,
    double? positionLeft,
    Alignment? notificationAlignment,
    int? apiThresholds,
    HttpMethod? httpMethod,
    bool? showRequestsStats,
    bool? showNotification,
    bool? showDeleteConfirmDialog,
  }) {
    return Settings(
      duration: duration ?? this.duration,
      notificationAlignment:
          notificationAlignment ?? this.notificationAlignment,
      apiThresholds: apiThresholds ?? this.apiThresholds,
      httpMethod: httpMethod ?? this.httpMethod,
      showNotification: showNotification ?? this.showNotification,
      showDeleteConfirmDialog:
          showDeleteConfirmDialog ?? this.showDeleteConfirmDialog,
      showRequestsStats: showRequestsStats ?? this.showRequestsStats,
      positionBottom: positionBottom ?? this.positionBottom,
      positionLeft: positionLeft ?? this.positionLeft,
      positionRight: positionRight ?? this.positionRight,
      positionTop: positionTop ?? this.positionTop,
    );
  }
}
