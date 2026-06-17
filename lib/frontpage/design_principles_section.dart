import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';

class DesignPrinciple {
  final String title;
  final String description;
  final IconData icon;

  const DesignPrinciple({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class DesignPrinciplesSection extends StatelessWidget {
  const DesignPrinciplesSection({super.key});

  static final List<DesignPrinciple> designPrinciples = [
    const DesignPrinciple(
      title: "Make everything a work of art",
      description:
          "Beauty runs through everything I do — from the design of UI elements to the structure of musical arrangements. It doesn't have to be loud, but it has look good.",
      icon: Icons.palette_outlined,
    ),
    const DesignPrinciple(
      title: "Less is more",
      description:
          "The real challenge isn't adding more — it's knowing what to leave out. I aim for software that is elegant at every level, from the interface down to the last line of code.",
      icon: Icons.auto_awesome_outlined,
    ),
    const DesignPrinciple(
      title: "Usability is key",
      description:
          "Features are only as good as the experience of using them. Good software is invisible — it gets out of the way and lets people do what they came to do.",
      icon: Icons.favorite_outline,
    )
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
          spacing: 12,
          children: [
            _buildTitle(context),
            const SizedBox(height: 0), // Resolves to 24px due to spacing
            for (final principle in designPrinciples)
              _buildPrinciple(context, principle),
          ],
        );

      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(context),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1024),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    for (final principle in designPrinciples)
                      Expanded(
                        child: _buildPrinciple(context, principle),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Design principles",
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPrinciple(
    BuildContext context,
    DesignPrinciple principle, {
    TextAlign alignment = TextAlign.center,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Icon(
                principle.icon,
                size: 100,
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    principle.title,
                    textAlign: alignment,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    principle.description,
                    textAlign: alignment,
                    style: descriptionTextStyle(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
