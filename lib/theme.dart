import 'package:flutter/material.dart';

final Gradient primaryGradient = LinearGradient(
  colors: <Color>[Colors.amber, Colors.red],
);

TextStyle? descriptionTextStyle(BuildContext context) {
  final Color color =
      Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa);
  return Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: color,
      );
}
