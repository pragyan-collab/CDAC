import 'package:flutter/material.dart';
import '../utils/argument_helper.dart';

class SafeNavigation {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Future<void> navigateTo(
      String routeName, {
        Object? arguments,
      }) async {
    if (arguments != null) {
      ArgumentHelper.setArguments(routeName, arguments);
    }

    navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<void> navigateReplacementTo(
      String routeName, {
        Object? arguments,
      }) async {
    if (arguments != null) {
      ArgumentHelper.setArguments(routeName, arguments);
    }

    navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<void> navigateAndRemoveUntil(
      String routeName,
      ) async {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
          (route) => false,
    );
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }
}