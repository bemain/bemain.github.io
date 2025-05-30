import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';

class DesignPriciple {
  final String title;
  final String description;
  final IconData icon;

  const DesignPriciple({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class DesignPrinciplesSection extends StatelessWidget {
  const DesignPrinciplesSection({super.key});

  static final List<DesignPriciple> designPrinciples = [
    const DesignPriciple(
      title: "Make everything a work of art",
      description:
          "Beauty is the thread that weaves through everything I do. It is the principle by which my brain operates and the force that drives me. It doesn't always have to be flamboyant or excessive, but it has to look good.",
      icon: Icons.palette_outlined,
    ),
    const DesignPriciple(
      title: "Less is more",
      description:
          "Anyone can write code that is cluttered. The true challenge lies in creating software that is elegant in every aspect, from the UI down to the last line of code. Make much with little.",
      icon: Icons.auto_awesome_outlined,
    ),
    const DesignPriciple(
      title: "Usability is key",
      description:
          "A program might have hundreds of features, but if it is hard to use it is still worthless. True power comes from making the hard things simple, and good software is intuitive, facilitating and easy to use.",
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
    DesignPriciple principle, {
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
