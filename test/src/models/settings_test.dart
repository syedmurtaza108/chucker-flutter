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
        settings.notificationAlignment.y,
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

  test('Should handle extreme duration values', () {
    final settings = Settings.defaultObject().copyWith(
      duration: Duration.zero,
    );
    expect(settings.duration.inSeconds, 0);

    final longDuration = Settings.defaultObject().copyWith(
      duration: const Duration(hours: 24),
    );
    expect(longDuration.duration.inHours, 24);
  });

  test('Should handle all alignment values', () {
    final alignments = [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight,
    ];

    for (final alignment in alignments) {
      final settings = Settings.defaultObject().copyWith(
        notificationAlignment: alignment,
      );
      expect(settings.notificationAlignment, alignment);
    }
  });

  test('Should handle all HttpMethod enum values', () {
    for (final method in HttpMethod.values) {
      final settings = Settings.defaultObject().copyWith(httpMethod: method);
      expect(settings.httpMethod, method);
    }
  });

  test('Should handle all Language enum values', () {
    for (final language in Language.values) {
      final settings = Settings.defaultObject().copyWith(language: language);
      expect(settings.language, language);
    }
  });

  test('Should handle zero and negative position values', () {
    final settings = Settings.defaultObject().copyWith(
      positionBottom: 0,
      positionTop: 0,
      positionLeft: 0,
      positionRight: 0,
    );

    expect(settings.positionBottom, 0.0);
    expect(settings.positionTop, 0.0);
    expect(settings.positionLeft, 0.0);
    expect(settings.positionRight, 0.0);
  });

  test('Should toggle boolean values correctly', () {
    var settings = Settings.defaultObject().copyWith(showNotification: true);
    expect(settings.showNotification, true);

    settings = settings.copyWith(showNotification: false);
    expect(settings.showNotification, false);

    settings = settings.copyWith(showDeleteConfirmDialog: true);
    expect(settings.showDeleteConfirmDialog, true);

    settings = settings.copyWith(showRequestsStats: true);
    expect(settings.showRequestsStats, true);
  });

  test('Should handle very large threshold values', () {
    final settings = Settings.defaultObject().copyWith(
      apiThresholds: 999999,
    );
    expect(settings.apiThresholds, 999999);
  });

  test('defaultObject should return consistent values', () {
    final settings1 = Settings.defaultObject();
    final settings2 = Settings.defaultObject();

    expect(settings1, settings2);
    expect(settings1.duration, settings2.duration);
    expect(settings1.notificationAlignment, settings2.notificationAlignment);
    expect(settings1.apiThresholds, settings2.apiThresholds);
  });

  test('Should preserve all values through toJson and fromJson cycle', () {
    final original = getMockedSettings();
    final json = original.toJson();
    final restored = Settings.fromJson(json);

    expect(restored.duration, original.duration);
    expect(restored.notificationAlignment, original.notificationAlignment);
    expect(restored.apiThresholds, original.apiThresholds);
    expect(restored.httpMethod, original.httpMethod);
    expect(restored.showNotification, original.showNotification);
    expect(restored.showDeleteConfirmDialog, original.showDeleteConfirmDialog);
    expect(restored.showRequestsStats, original.showRequestsStats);
    expect(restored.positionBottom, original.positionBottom);
    expect(restored.positionLeft, original.positionLeft);
    expect(restored.positionRight, original.positionRight);
    expect(restored.positionTop, original.positionTop);
    expect(restored.language, original.language);
  });
}
