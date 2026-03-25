import 'package:flutter/material.dart';

/// Generic skeleton list builder.
class KioskSkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  const KioskSkeletonList({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

