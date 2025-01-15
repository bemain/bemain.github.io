import 'package:flutter/material.dart';

class TitleButton extends StatelessWidget {
  const TitleButton({super.key, required this.onPressed, required this.child});

  final Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(24),
        textStyle: Theme.of(context).textTheme.titleLarge,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
