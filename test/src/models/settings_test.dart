import 'package:chucker_flutter/src/models/settings.dart';
import 'package:chucker_flutter/src/view/helper/http_methods.dart';
import 'package:chucker_flutter/src/view/helper/languages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Settings getMockedSettings() {
    const duration = Duration(seconds: 100);
    const alignment = Alignment.center;
    const threshold = 400;
    const method = HttpMethod.delete;
    const showNotification = false;
    const showDeleteConfirmDialog = true;
    const showRequestsStats = false;
    const bottom = -1.0;
    const top = -1.0;
    const left = -1.0;
    const right = -1.0;
    const language = Language.urdu;

    final settings = Settings(
      duration: duration,
      notificationAlignment: alignment,
      apiThresholds: threshold,
      httpMethod: method,
      showNotification: showNotification,
      showDeleteConfirmDialog: showDeleteConfirmDialog,
      showRequestsStats: showRequestsStats,
      positionBottom: bottom,
      positionLeft: left,
      positionRight: right,
      positionTop: top,
      language: language,
    );
    return settings;
  }

  test('Two instances should equal if their all attributes are equal', () {
    final model1 = Settings.defaultObject();
    final model2 = Settings.defaultObject();
    expect(model1, model2);
  });

  test('CopyWith should copy each attribute properly', () {
    final settings = getMockedSettings();
    final newSettings = Settings.defaultObject().copyWith(
      duration: settings.duration,
      notificationAlignment: settings.notificationAlignment,
      apiThresholds: settings.apiThresholds,
      httpMethod: settings.httpMethod,
      showNotification: settings.showNotification,
      showDeleteConfirmDialog: settings.showDeleteConfirmDialog,
      showRequestsStats: settings.showRequestsStats,
      positionBottom: settings.positionBottom,
      positionLeft: settings.positionLeft,
      positionRight: settings.positionRight,
      positionTop: settings.positionTop,
      language: settings.language,
    );

    expect(settings, newSettings);
  });

  test('toJson should convert each attribute to its respective key', () {
    final settings = getMockedSettings();
    final json = {
      'duration': settings.duration.inSeconds,
      'notificationAlignment': [
        settings.notificationAlignment.x,
        settings.notificationAlignment.y
      ],
      'apiThresholds': settings.apiThresholds,
      'httpMethod': settings.httpMethod.index,
      'showNotification': settings.showNotification,
      'showDeleteConfirmDialog': settings.showDeleteConfirmDialog,
      'showRequestsStats': settings.showRequestsStats,
      'positionBottom': settings.positionBottom,
      'positionLeft': settings.positionLeft,
      'positionRight': settings.positionRight,
      'positionTop': settings.positionTop,
      'language': settings.language.index,
    };
    expect(json, settings.toJson());
  });

  test('fromJson should convert each key to its respective attribute', () {
    final settings = getMockedSettings();

    final toJson = settings.toJson();
    final fromSettings = Settings.fromJson(toJson);

    expect(settings, fromSettings);
  });

  test('hashCode should return request time in milliseconds', () {
    final settings = getMockedSettings();

    final hash = Object.hash(
      settings.apiThresholds,
      settings.duration,
      settings.httpMethod,
      settings.language,
      settings.notificationAlignment,
      settings.positionBottom,
      settings.positionLeft,
      settings.positionRight,
      settings.positionTop,
      settings.showDeleteConfirmDialog,
      settings.showNotification,
      settings.showRequestsStats,
    );
    expect(settings.hashCode, hash);
  });
}
