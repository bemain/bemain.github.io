import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';

class Characteristic {
  const Characteristic({
    required this.adjective,
    required this.title,
    required this.icon,
  });

  /// Adjective describing the characteristic, preceding the title.
  final String adjective;

  /// Title describing the characteristic.
  final String title;

  /// Icon representing the characteristic.
  final Widget icon;
}

class AboutMeSection extends StatelessWidget {
  const AboutMeSection({super.key, required this.windowSize});

  final WindowSize windowSize;

  static final List<Characteristic> characteristics = [
    Characteristic(
      adjective: "Swedish",
      title: "Engineering student",
      icon: Icon(Icons.school_outlined),
    ),
    Characteristic(
      adjective: "Skilled",
      title: "Mobile developer",
      icon: Icon(Icons.code),
    ),
    Characteristic(
      adjective: "Passionate",
      title: "Musician & Conductor",
      icon: Icon(Icons.music_note_outlined),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: windowSize.padding.add(EdgeInsets.symmetric(vertical: 32)),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (windowSize) {
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
                _buildDescription(context),
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
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 380),
      child: Text(
        """I'm driven by the challenge of creating intuitive user experiences powered by innovative technology.""",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withAlpha(0xaa),
            ),
        textAlign: TextAlign.center,
      ),
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
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          radius: 32,
          child: characteristic.icon,
        ),
        const SizedBox(height: 8),
        Text(
          characteristic.adjective,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withAlpha(0xaa),
              ),
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
          child: CircleAvatar(
            maxRadius: 160,
            foregroundImage: AssetImage("assets/me/portrait2.jpg"),
          ),
        ),
      ),
    );
  }
}
