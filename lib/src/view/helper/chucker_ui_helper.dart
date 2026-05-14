import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/models/settings.dart';
import 'package:chucker_flutter/src/view/chucker_page.dart';
import 'package:chucker_flutter/src/view/helper/chucker_button.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/widgets/notification.dart'
    as notification;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///[ChuckerUiHelper] handles the UI part of `chucker_flutter`
///
///You must attach [ChuckerFlutter.navigatorKey] to your root `MaterialApp`'s
///`navigatorKey` — it is required to show notifications and the screens of
///`chucker_flutter`. The legacy `ChuckerFlutter.navigatorObserver` is still
///supported as a fallback but is deprecated and unreliable when the host app
///uses nested `Navigator`s.
class ChuckerUiHelper {
  static final List<OverlayEntry?> _overlayEntries = List.empty(growable: true);

  ///Only for testing
  static bool notificationShown = false;

  ///[settings] to modify ui behaviour of chucker screens and notification
  static Settings settings = Settings.defaultObject();

  ///[showNotification] shows the rest api [method] (GET, POST, PUT, etc),
  ///[statusCode] (200, 400, etc) response status and [path]
  static bool showNotification({
    required String method,
    required int statusCode,
    required String path,
    required DateTime requestTime,
  }) {
    notificationShown = false;

    if (!ChuckerUiHelper.settings.showNotification) {
      debugPrint(
        '''
ChuckerFlutter: Your notification setting is off. You can turn it on by visiting the settings page from Chucker Flutter screen.
        ''',
      );
      return false;
    }
    final navigator = _resolveNavigator();
    if (navigator == null) {
      debugPrint(
        '''
ChuckerFlutter: You didn't attach ChuckerFlutter.navigatorKey to your MaterialApp (or the deprecated ChuckerFlutter.navigatorObserver). Visit https://github.com/syedmurtaza108/chucker-flutter#getting-started for Chucker Integration details.
        ''',
      );
      return false;
    }
    if (!ChuckerFlutter.showNotification) {
      debugPrint(
        '''
ChuckerFlutter: You programmatically vetoed notification behavior. Make sure to remove `ChuckerFlutter.showNotification = true` to continue receiving notifications.
        ''',
      );
      return false;
    }

    final overlay = navigator.overlay;
    final entry = _createOverlayEntry(method, statusCode, path, requestTime);
    _overlayEntries.add(entry);
    overlay?.insert(entry);
    notificationShown = true;
    return true;
  }

  static OverlayEntry _createOverlayEntry(
    String method,
    int statusCode,
    String path,
    DateTime requestTime,
  ) {
    return OverlayEntry(
      builder: (context) {
        return Align(
          alignment: settings.notificationAlignment,
          child: notification.Notification(
            statusCode: statusCode,
            method: method,
            path: path,
            removeNotification: _removeNotification,
            requestTime: requestTime,
          ),
        );
      },
    );
  }

  static NavigatorState? _resolveNavigator() {
    // currentState requires an initialized widget binding; catch the assertion
    // that fires when the interceptor is called before runApp (e.g. in tests).
    NavigatorState? fromKey;
    try {
      fromKey = ChuckerFlutter.navigatorKey.currentState;
    } catch (_) {}
    return fromKey ??
        // ignore: deprecated_member_use_from_same_package
        ChuckerFlutter.navigatorObserver.navigator;
  }

  static void _removeNotification() {
    for (final entry in _overlayEntries) {
      if (entry != null) {
        entry.remove();
      }
    }
    _overlayEntries.clear();
  }

  ///[showChuckerScreen] shows the screen containing the list of records
  ///api requests
  static void showChuckerScreen() {
    SharedPreferencesManager.getInstance().getSettings();
    final navigator = _resolveNavigator();
    if (navigator == null) {
      debugPrint(
        '''
ChuckerFlutter: Cannot open Chucker screen — attach ChuckerFlutter.navigatorKey to your MaterialApp. Visit https://github.com/syedmurtaza108/chucker-flutter#getting-started for Chucker Integration details.
        ''',
      );
      return;
    }
    navigator.push(
      MaterialPageRoute<void>(
        builder: (context) => MaterialApp(
          key: const Key('chucker_material_app'),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: Localization.localizationsDelegates,
          supportedLocales: Localization.supportedLocales,
          locale: Localization.currentLocale,
          theme: ThemeData(
            useMaterial3: false,
            tabBarTheme: TabBarThemeData(
              labelColor: Colors.white,
              labelStyle: context.textTheme.bodyLarge,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  surface: primaryColor,
                ),
          ),
          home: const ChuckerPage(),
        ),
      ),
    );
  }
}

///[ChuckerFlutter] is a helper class to initialize the library
///
///[chuckerButton] and notifications only be visible in debug mode
class ChuckerFlutter {
  ///Prevents instantiation; every member on this type is static.
  const ChuckerFlutter._();

  ///[navigatorKey] is the recommended way to wire `chucker_flutter` into your
  ///app. Attach it to your root `MaterialApp.navigatorKey` so Chucker can show
  ///notifications and open its inspector against the root navigator — this
  ///works reliably even when your app uses nested `Navigator`s (bottom-nav
  ///shells, `ShellRoute`, modal flows, etc.).
  ///
  ///```dart
  ///MaterialApp(
  ///  navigatorKey: ChuckerFlutter.navigatorKey,
  ///  ...,
  ///)
  ///```
  static final navigatorKey = GlobalKey<NavigatorState>();

  ///[navigatorObserver] observes the navigation of your app.
  ///
  ///Deprecated: use [navigatorKey] instead. The observer-based integration is
  ///unreliable with nested `Navigator`s because it tracks whichever navigator
  ///last fired a route event, which may not be the root one.
  @Deprecated(
    'Use ChuckerFlutter.navigatorKey on MaterialApp.navigatorKey instead. '
    'Observer-based wiring is unreliable with nested Navigators.',
  )
  static final navigatorObserver = NavigatorObserver();

  ///[showOnRelease] decides whether to allow Chucker Flutter working in release
  ///mode or not.
  ///By default its value is `false`
  static bool showOnRelease = false;

  ///[isDebugMode] A wrapper of Flutter's `kDebugMode` constant
  static bool isDebugMode = kDebugMode;

  ///[showNotification] decides whether to show in app notification or not
  ///By default its value is `true`
  static bool showNotification = true;

  ///[ChuckerButton] can be placed anywhere in the UI to open Chucker Screen
  static final chuckerButton = (isDebugMode || ChuckerFlutter.showOnRelease)
      ? ChuckerButton.getInstance()
      : const SizedBox.shrink();

  ///Returns the current [NavigatorState] for use by internal Chucker screens.
  ///Prefers [navigatorKey]; falls back to the deprecated observer.
  static NavigatorState? get currentNavigator =>
      ChuckerUiHelper._resolveNavigator();

  ///[showChuckerScreen] navigates to the chucker home screen
  static void showChuckerScreen() => ChuckerUiHelper.showChuckerScreen();

  ///[ChuckerUiHelper] configuration overlay notification]
  static void configure({
    bool showOnRelease = false,
    bool showNotification = true,
    Alignment? notificationAlignment,
    Offset? offsetEnd,
    Offset? offsetBegin,
  }) {
    ChuckerFlutter.showOnRelease = showOnRelease;
    ChuckerFlutter.showNotification = showNotification;

    ChuckerUiHelper.settings = ChuckerUiHelper.settings.copyWith(
      notificationAlignment: notificationAlignment,
      offsetBegin: offsetEnd,
      offsetEnd: offsetBegin,
    );
  }
}
