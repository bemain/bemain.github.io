import 'package:flutter/material.dart';

/// A window size class is an opinionated breakpoint, the window size at which a
/// layout needs to change to match available space, device conventions, and ergonomics.
///
/// These window sizes are taken from the [Material Design 3 guidelines](https://m3.material.io/foundations/layout/applying-layout/window-size-classes).
enum WindowSize {
  compact(horizontalMargin: 16),
  medium(horizontalMargin: 24),
  expanded(horizontalMargin: 24),
  large(horizontalMargin: 24),
  extraLarge(horizontalMargin: 24);

  const WindowSize({required this.horizontalMargin});

  /// The horizontal margin for the window size.
  final double horizontalMargin;

  /// The space between the edge of the window and the content.
  EdgeInsets get margin => EdgeInsets.symmetric(horizontal: horizontalMargin);

  static WindowSize of(BuildContext context) {
    return WindowSize.fromSize(MediaQuery.sizeOf(context));
  }

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
