// lib/services/navigation_service.dart
import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  static final NavigationService instance = NavigationService();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?>? pushNamed<T extends Object?>(
      String routeName, {
        Object? arguments,
      }) {
    return Future.microtask(() {
      return navigatorKey.currentState?.pushNamed<T>(
        routeName,
        arguments: arguments,
      );
    });
  }

  Future<T?>? pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName, {
        Object? arguments,
      }) {
    return Future.microtask(() {
      return navigatorKey.currentState?.pushReplacementNamed<T, TO>(
        routeName,
        arguments: arguments,
      );
    });
  }

  void pop<T extends Object?>([T? result]) {
    Future.microtask(() {
      navigatorKey.currentState?.pop<T>(result);
    });
  }

  void pushNamedAndRemoveUntil(String routeName) {
    Future.microtask(() {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName,
            (route) => false,
      );
    });
  }
}