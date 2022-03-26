import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/localization/localization.dart';

import 'package:chucker_flutter/src/models/settings.dart';
import 'package:chucker_flutter/src/view/chucker_page.dart';
import 'package:chucker_flutter/src/view/helper/chucker_button.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/widgets/notification.dart'
    as notification;
import 'package:flutter/material.dart';

///[ChuckerUiHelper] handles the UI part of `chucker_flutter`
///
///You must initialize ChuckerObserver in the `MaterialApp`
///of your application as it is required to show notification and the screens
///of `chucker_flutter`
class ChuckerUiHelper {
  static OverlayEntry? _overlayEntry;

  ///[settings] to modify ui behaviour of chucker screens and notification
  static Settings settings = Settings.defaultObject();

  ///[showNotification] shows the rest api [method] (GET, POST, PUT, etc),
  ///[statusCode] (200, 400, etc) response status and [path]
  static void showNotification({
    required String method,
    required int statusCode,
    required String path,
  }) {
    if (ChuckerUiHelper.settings.showNotification &&
        ChuckerFlutter.navigatorObserver.navigator != null) {
      final overlay = ChuckerFlutter.navigatorObserver.navigator!.overlay;
      _overlayEntry = _createOverlayEntry(method, statusCode, path);
      overlay?.insert(_overlayEntry!);
    }
  }

  static OverlayEntry _createOverlayEntry(
    String method,
    int statusCode,
    String path,
  ) {
    return OverlayEntry(
      builder: (context) {
        if (_isPositionGiven) {
          return Positioned(
            top: settings.positionTop,
            left: settings.positionLeft,
            right: settings.positionRight,
            bottom: settings.positionBottom,
            child: notification.Notification(
              statusCode: statusCode,
              method: method,
              path: path,
              removeNotification: _removeNotification,
            ),
          );
        }

        return Align(
          alignment: settings.notificationAlignment,
          child: notification.Notification(
            statusCode: statusCode,
            method: method,
            path: path,
            removeNotification: _removeNotification,
          ),
        );
      },
    );
  }

  static void _removeNotification() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
  }

  static bool get _isPositionGiven =>
      settings.positionBottom.isNotZero ||
      settings.positionTop.isNotZero ||
      settings.positionRight.isNotZero ||
      settings.positionLeft.isNotZero;

  ///[showChuckerScreen] shows the screen containing the list of recored
  ///api requests
  static void showChuckerScreen() {
    SharedPreferencesManager.getInstance().getSettings();
    final context = ChuckerFlutter.navigatorObserver.navigator!.context;
    context.navigator.push(
      MaterialPageRoute(
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: Localization.localizationsDelegates,
          supportedLocales: Localization.supportedLocales,
          locale: Localization.currentLocale,
          theme: ThemeData(
            tabBarTheme: TabBarTheme(
              labelColor: Colors.white,
              labelStyle: context.theme.textTheme.bodyText1,
            ),
            backgroundColor: primaryColor,
          ),
          home: const ChuckerPage(),
        ),
      ),
    );
  }
}

///[ChuckerFlutter] is a helper class to initialize the library
class ChuckerFlutter {
  ///[navigatorObserver] observes the navigation of your app. It must be
  ///referenced in your MaterialApp widget
  static final navigatorObserver = NavigatorObserver();

  ///[ChuckerButton] can be placed anywhere in the UI to open Chucker Screen
  static final chuckerButton = ChuckerButton.getInstance();
}
