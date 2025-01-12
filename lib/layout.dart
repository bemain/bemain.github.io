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

  static WindowSize fromSize(Size size) {
    return switch (size.width) {
      < 600 => WindowSize.compact,
      < 840 => WindowSize.medium,
      < 1200 => WindowSize.expanded,
      < 1600 => WindowSize.large,
      _ => WindowSize.extraLarge,
    };
  }
}
