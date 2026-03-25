import 'package:flutter/material.dart';
import 'loading_widget.dart';

/// Simple kiosk overlay to block multiple taps and show a loader.
class KioskBusyOverlay extends StatelessWidget {
  final bool isBusy;
  final Widget child;
  final String? message;

  const KioskBusyOverlay({
    Key? key,
    required this.isBusy,
    required this.child,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isBusy)
          Positioned.fill(
            child: Material(
              color: Colors.black.withOpacity(0.08),
              child: Center(
                child: LoadingWidget(message: message),
              ),
            ),
          ),
      ],
    );
  }
}

