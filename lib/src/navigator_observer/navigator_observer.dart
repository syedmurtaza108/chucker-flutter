import 'package:flutter/material.dart';

import 'navigator_observer_helper.dart';

class ChuckerNavigatorObserver extends NavigatorObserver {
  static final List<NavigatorObserverHelper> _callBacks = [];

  static bool debugInitialization = false;

  static void register(NavigatorObserverHelper navigatorObserverHelper) {
    _callBacks.add(navigatorObserverHelper);
  }

  static void unregister(NavigatorObserverHelper navigatorObserverHelper) {
    _callBacks.remove(navigatorObserverHelper);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final copy = _callBacks.toList(growable: false);
    for (final observerHelper in copy) {
      observerHelper.pushed?.call(route, previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final copy = _callBacks.toList(growable: false);
    for (final observerHelper in copy) {
      observerHelper.replaced?.call(newRoute, oldRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final copy = _callBacks.toList(growable: false);
    for (final observerHelper in copy) {
      observerHelper.removed?.call(route, previousRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final copy = _callBacks.toList(growable: false);
    for (final observerHelper in copy) {
      observerHelper.popped?.call(route, previousRoute);
    }
  }
}
