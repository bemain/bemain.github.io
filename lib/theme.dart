import 'package:flutter/material.dart';

const Color seedColor = Colors.deepOrange;

final Gradient primaryGradient = LinearGradient(
  colors: <Color>[Colors.cyan, Colors.indigo],
);

TextStyle? descriptionTextStyle(BuildContext context) {
  final Color color =
      Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa);
  return Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: color,
      );
}
