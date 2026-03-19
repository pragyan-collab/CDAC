// lib/utils/error_handler.dart
import 'package:flutter/foundation.dart';

class ErrorHandler {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kReleaseMode) {
        debugPrint('FlutterError: ${details.exception}');
        debugPrint('Stack: ${details.stack}');
      } else {
        FlutterError.dumpErrorToConsole(details);
      }
    };
  }
}