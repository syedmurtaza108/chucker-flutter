import 'package:flutter/material.dart';

class NavigatorObserverHelper {
  NavigatorObserverHelper({
    this.pushed,
    this.replaced,
    this.removed,
    this.popped,
  });
  NavigatorObserverHelper.all(VoidCallback leavePageCallback) {
    pushed = (_, __) => leavePageCallback();
    replaced = (_, __) => leavePageCallback();
    removed = (_, __) => leavePageCallback();
    popped = (_, __) => leavePageCallback();
  }
  
  void Function(Route<dynamic> route, Route<dynamic>? previousRoute)? pushed;
  void Function(Route<dynamic>? newRoute, Route<dynamic>? oldRoute)? replaced;
  void Function(Route<dynamic> route, Route<dynamic>? previousRoute)? removed;
  void Function(Route<dynamic> route, Route<dynamic>? previousRoute)? popped;
}
