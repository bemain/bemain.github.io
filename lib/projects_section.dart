import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';

class Project {
  Project({
    required this.title,
    required this.description,
    required this.image,
    this.startDate,
    this.endDate,
  })  : // Start date must be before end date
        assert(startDate == null ||
            endDate == null ||
            startDate == endDate ||
            startDate.isBefore(endDate)),
        // If there is an end date, there must be a start date
        assert(startDate != null || endDate == null);

  /// The title of the project
  final String title;

  /// A short description of the project
  final String description;

  /// An image representing the project
  final ImageProvider image;

  /// The start date of the project
  final DateTime? startDate;

  /// The end date of the project. If null, the project is ongoing.
  final DateTime? endDate;
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key, required this.windowSize});

  final WindowSize windowSize;

  static final List<Project> projects = [
    Project(
      title: "Musician's Toolbox",
      description:
          "A mobile app that offers everything a musician needs for transcribing, practicing and performing.",
      image: AssetImage("assets/projects/treble_clef.png"),
      startDate: DateTime(2022),
    ),
    Project(
      title: "Dirma",
      description:
          "A website for the Swedish company Dirma, built using TypeScript and Next.js.",
      image: AssetImage("assets/projects/dirma.png"),
      startDate: DateTime(2023),
      endDate: DateTime(2023),
    ),
    Project(
      title: "Märklin Bluetooth controller",
      description:
          "A wireless hand controller for Märklin Sprint using Bluetooth LE.",
      image: AssetImage("assets/projects/car.png"),
      startDate: DateTime(2021),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    switch (windowSize) {
      case WindowSize.compact:
        return Padding(
          padding: windowSize.padding.add(EdgeInsets.symmetric(vertical: 32)),
          child: Column(
            children: [
              _buildTitle(context),
              const SizedBox(height: 24),
              for (final Project project in projects)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: _buildProjectCard(context, project),
                ),
            ],
          ),
        );

      default:
        return Padding(
          padding: windowSize.padding.add(EdgeInsets.symmetric(vertical: 32)),
          child: Column(
            children: [
              _buildTitle(context),
              const SizedBox(height: 24),
              GridView.extent(
                childAspectRatio: 0.9,
                maxCrossAxisExtent: 360,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final Project project in projects)
                    _buildProjectCard(context, project),
                ],
              ),
            ],
          ),
        );
    }
  }

  Widget _buildTitle(
    BuildContext context, {
    String text = "Some of my recent projects",
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => print("Tapped on ${project.title}"),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Card.filled(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  child: AspectRatio(
                    aspectRatio: 1.618,
                    child: Image(
                      image: project.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: _buildProjectText(context, project),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectText(BuildContext context, Project project) {
    final Color subtitleColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa);
    final TextStyle? descriptionStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: subtitleColor,
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          project.title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
        Text(
          project.description,
          style: descriptionStyle,
        ),
        if (project.startDate != null)
          RichText(
            text: TextSpan(
              style: descriptionStyle,
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(Icons.timeline, color: subtitleColor),
                ),
                TextSpan(text: "  ${project.startDate?.year}"),
                if (project.endDate != project.startDate)
                  TextSpan(
                    text: " - ${project.endDate?.year ?? "present"}",
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
