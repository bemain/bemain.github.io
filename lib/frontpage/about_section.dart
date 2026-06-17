import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';

class Characteristic {
  /// A characteristic describing me.
  const Characteristic({
    required this.adjective,
    required this.title,
    required this.icon,
    this.shape = Shapes.circle,
  });

  /// Adjective describing the characteristic, preceding the title.
  final String adjective;

  /// Title describing the characteristic.
  final String title;

  /// Icon representing the characteristic.
  final Widget icon;

  /// The shape used around this characteristic.
  final Shapes shape;
}

class AboutMeSection extends StatelessWidget {
  /// A section displaying a short description of me and my characteristics.
  const AboutMeSection({super.key});

  static final List<Characteristic> characteristics = [
    Characteristic(
      adjective: "Curious",
      title: "Engineering student",
      icon: Icon(Icons.school_outlined),
      shape: Shapes.square,
    ),
    Characteristic(
      adjective: "Creative",
      title: "Software developer",
      icon: Icon(Icons.code),
      shape: Shapes.diamond,
    ),
    Characteristic(
      adjective: "Passionate",
      title: "Musician & Conductor",
      icon: Icon(Icons.music_note_outlined),
      shape: Shapes.circle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    return Padding(
      padding: windowSize.margin.add(EdgeInsets.symmetric(vertical: 32)),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (WindowSize.of(context)) {
      case WindowSize.compact:
      case WindowSize.medium:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle(context),
            const SizedBox(height: 12),
            Center(
              child: _buildDescription(context),
            ),
            const SizedBox(height: 32),
            _buildCharacteristics(context),
            const SizedBox(height: 32),
            _buildPortrait(context),
          ],
        );

      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(context),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 380),
                  child: _buildDescription(context),
                ),
                const SizedBox(height: 32),
                _buildCharacteristics(context),
              ],
            ),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 360),
                child: _buildPortrait(context),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Hi, I'm Benjamin!",
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      """I live for the joy of creating harmony out of chaos and building things that work beautifully.""",
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:
                Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa),
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCharacteristics(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            for (final characteristic in characteristics)
              Expanded(
                child: _buildCharacteristic(context, characteristic),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacteristic(
    BuildContext context,
    Characteristic characteristic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        M3Container(
          characteristic.shape,
          clipBehavior: Clip.antiAlias,
          width: 64,
          height: 64,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: IconTheme(
            data: IconThemeData(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
            child: characteristic.icon,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          characteristic.adjective,
          style: descriptionTextStyle(context),
          textAlign: TextAlign.center,
        ),
        Text(
          characteristic.title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: FittedBox(
          fit: BoxFit.cover,
          child: M3Container.c7SidedCookie(
            clipBehavior: Clip.antiAlias,
            width: 320,
            height: 320,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Image(
              image: AssetImage("assets/me/portrait2.jpg"),
            ),
          ),
        ),
      ),
    );
  }
}
