// lib/utils/argument_helper.dart
import 'package:flutter/material.dart';

class ArgumentHelper {
  // Thread-safe argument storage
  static final Map<String, dynamic> _argumentCache = {};

  // Store arguments before navigation
  static void setArguments(String routeName, dynamic arguments) {
    _argumentCache[routeName] = arguments;
  }

  // Get arguments safely - call this in initState
  static T? getArgument<T>(BuildContext context, {String? routeName}) {
    try {
      // Try to get from ModalRoute first
      final route = ModalRoute.of(context);
      if (route != null && route.settings.arguments != null) {
        final args = route.settings.arguments;
        // Cache for future reference
        if (route.settings.name != null) {
          _argumentCache[route.settings.name!] = args;
        }
        return args as T?;
      }

      // Fallback to cached arguments
      if (routeName != null && _argumentCache.containsKey(routeName)) {
        return _argumentCache[routeName] as T?;
      }

      // Try to get from current route name
      final currentRoute = ModalRoute.of(context);
      if (currentRoute != null && currentRoute.settings.name != null) {
        final cached = _argumentCache[currentRoute.settings.name!];
        if (cached != null) {
          return cached as T?;
        }
      }
    } catch (e) {
      debugPrint('Error getting arguments: $e');
    }
    return null;
  }

  // Clear cache when done
  static void clearArguments(String routeName) {
    _argumentCache.remove(routeName);
  }
}