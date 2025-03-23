import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteObservers extends GetObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    log("Navigated to: ${route.settings.name}");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    log("Popped back to: ${previousRoute?.settings.name}");
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    log("Route removed: ${route.settings.name}");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    log("Replaced: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}");
  }
}
