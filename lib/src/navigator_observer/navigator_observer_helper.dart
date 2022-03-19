import 'package:flutter/material.dart';

///[NavigatorObserverHelper] helps observing route while popping, replacing,
///removing and pushing a route
class NavigatorObserverHelper {
  ///[NavigatorObserverHelper] helps observing route while popping, replacing,
  ///removing and pushing a route
  NavigatorObserverHelper({
    this.pushed,
    this.replaced,
    this.removed,
    this.popped,
  });

  ///callback after a route pushed
  void Function(Route<dynamic> route, Route<dynamic>? previousRoute)? pushed;
  ///callback after a route replaced
  void Function(Route<dynamic>? newRoute, Route<dynamic>? oldRoute)? replaced;
  ///callback after a route removed
  void Function(Route<dynamic> route, Route<dynamic>? previousRoute)? removed;
  ///callback after a route popped
  void Function(Route<dynamic> route, Route<dynamic>? previousRoute)? popped;
}
