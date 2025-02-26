import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IconImage extends ImageProvider<IconImage> {
  final IconData icon;
  final double scale;
  final int size;
  final Color color;

  IconImage(this.icon,
      {this.scale = 1.0, this.size = 24, this.color = Colors.black});

  @override
  int get hashCode => Object.hash(icon.hashCode, scale, size, color);
  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    final IconImage typedOther = other as IconImage;
    return icon == typedOther.icon &&
        scale == typedOther.scale &&
        size == typedOther.size &&
        color == typedOther.color;
  }

  @override
  ImageStreamCompleter loadImage(IconImage key, ImageDecoderCallback decode) =>
      OneFrameImageStreamCompleter(_loadAsync(key));

  @override
  Future<IconImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<IconImage>(this);

  @override
  String toString() =>
      '$runtimeType(${describeIdentity(icon)}, scale: $scale, size: $size, color: $color)';

  Future<ImageInfo> _loadAsync(IconImage key) async {
    assert(key == this);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(scale, scale);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size.toDouble(),
        fontFamily: icon.fontFamily,
        color: color,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
    final image = await recorder.endRecording().toImage(size, size);
    return ImageInfo(image: image, scale: key.scale);
  }
}

class TitleButton extends StatelessWidget {
  final Function()? onPressed;

  final Widget child;
  const TitleButton({super.key, required this.onPressed, required this.child});

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
