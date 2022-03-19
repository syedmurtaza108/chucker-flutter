import 'package:chucker_flutter/src/navigator_observer/navigator_observer_helper.dart';
import 'package:flutter/material.dart';

///[ChuckerNavigatorObserver] helps observing route
class ChuckerNavigatorObserver extends NavigatorObserver {
  static final List<NavigatorObserverHelper> _callBacks = [];

  ///[register] registers a [NavigatorObserverHelper] to
  ///[ChuckerNavigatorObserver]
  static void register(NavigatorObserverHelper navigatorObserverHelper) {
    _callBacks.add(navigatorObserverHelper);
  }

  ///[unregister] removes a [NavigatorObserverHelper] from
  ///[ChuckerNavigatorObserver]
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
