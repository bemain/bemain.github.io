import 'package:flutter/material.dart';

enum WindowSize {
  compact(horizontalMargin: 16),
  medium(horizontalMargin: 24),
  expanded(horizontalMargin: 24),
  large(horizontalMargin: 24),
  extraLarge(horizontalMargin: 24);

  const WindowSize({required this.horizontalMargin});

  final double horizontalMargin;

  EdgeInsets get padding => EdgeInsets.symmetric(horizontal: horizontalMargin);
}
