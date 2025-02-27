import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';
import 'package:portfolio/widgets.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class Project {
  Project({
    required this.title,
    required this.description,
    required this.image,
    this.startDate,
    this.endDate,
    this.links = const [],
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

  final List<ProjectLink> links;
}

class ProjectLink {
  /// A link to a project, such as a website or a repository.
  ProjectLink({
    required this.title,
    required this.icon,
    required this.uri,
  });

  /// A title describing the link
  final String title;

  /// An icon representing the link
  final ImageProvider icon;

  /// The URI that the link opens
  final Uri uri;
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static final List<Project> projects = [
    Project(
      title: "Musician's Toolbox",
      description:
          "A mobile app that offers everything a musician needs for transcribing, practicing and performing.",
      image: AssetImage("assets/projects/treble_clef.png"),
      startDate: DateTime(2022),
      links: [
        ProjectLink(
          title: "Google Play",
          icon: AssetImage("assets/icons/google-play.png"),
          uri: Uri.parse(
              "https://play.google.com/store/apps/details?id=se.agardh.musbx&pcampaignid=portfolio"),
        ),
        ProjectLink(
          title: "App Store",
          icon: AssetImage("assets/icons/app-store.png"),
          uri: Uri.parse(
              "https://apps.apple.com/se/app/musicians-toolbox/id1670009655"),
        ),
      ],
    ),
    Project(
      title: "Dirma",
      description:
          "A website for the Swedish company Dirma, built using TypeScript and Next.js.",
      image: AssetImage("assets/projects/dirma.png"),
      startDate: DateTime(2023),
      endDate: DateTime(2023),
      links: [
        ProjectLink(
          title: "Website",
          icon: IconImage(Icons.public),
          uri: Uri.parse("https://dirma.se"),
        ),
      ],
    ),
    Project(
      title: "Märklin Bluetooth controller",
      description:
          "A wireless hand controller for Märklin Sprint using Bluetooth LE.",
      image: AssetImage("assets/projects/car.png"),
      startDate: DateTime(2021),
      endDate: DateTime(2022),
      links: [
        ProjectLink(
          title: "GitHub",
          icon: AssetImage("assets/icons/github-mark.png"),
          uri: Uri.parse("https://github.com/bemain/marklin_client"),
        ),
      ],
    ),
    Project(
      title: "Oxdjupet lajv",
      description:
          "A mobile app used during the larp I arrange yearly at Oxdjupet.",
      image: AssetImage("assets/projects/oxdjupet.png"),
      startDate: DateTime(2021),
      links: [
        ProjectLink(
          title: "Google Play",
          icon: AssetImage("assets/icons/google-play.png"),
          uri: Uri.parse(
              "https://play.google.com/store/apps/details?id=se.agardh.lajv&pcampaignid=portfolio"),
        ),
        ProjectLink(
          title: "App Store",
          icon: AssetImage("assets/icons/app-store.png"),
          uri: Uri.parse(
              "https://apps.apple.com/se/app/oxdjupet-lajv/id6504813711"),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    switch (windowSize) {
      case WindowSize.compact:
        return Padding(
          padding: windowSize.margin.add(EdgeInsets.symmetric(vertical: 32)),
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
          padding: windowSize.margin.add(EdgeInsets.symmetric(vertical: 32)),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1024),
              child: Column(
                children: [
                  _buildTitle(context),
                  const SizedBox(height: 24),
                  GridView.extent(
                    childAspectRatio: 0.8,
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
            ),
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
        onTap: project.links.isEmpty
            ? null
            : () {
                launchUrl(project.links.first.uri);
              },
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
              const SizedBox(height: 4),
              for (ProjectLink link in project.links)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Link(
                    uri: link.uri,
                    builder: (context, followLink) {
                      return TextButton.icon(
                        onPressed: followLink,
                        icon: Image(
                          image: link.icon,
                          color: descriptionTextStyle(context)?.color,
                          width: 20,
                          height: 20,
                        ),
                        label: Row(
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              link.title,
                              style: TextStyle(
                                color: descriptionTextStyle(context)?.color,
                              ),
                            ),
                            Icon(
                              Icons.open_in_new,
                              color: descriptionTextStyle(context)?.color,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectText(BuildContext context, Project project) {
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
          style: descriptionTextStyle(context),
        ),
        if (project.startDate != null)
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 6),
            child: RichText(
              text: TextSpan(
                style: descriptionTextStyle(context),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.timeline,
                      size: 20,
                      color: descriptionTextStyle(context)?.color,
                    ),
                  ),
                  TextSpan(text: "  ${project.startDate?.year}"),
                  if (project.endDate != project.startDate)
                    TextSpan(
                      text: " - ${project.endDate?.year ?? "present"}",
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
