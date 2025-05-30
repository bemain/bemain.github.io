import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

part 'projects_section.g.dart';

@JsonSerializable(explicitToJson: true)
class Project {
  Project({
    required this.title,
    required this.description,
    required this.imageUrl,
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

  /// An url to an image representing the project.
  /// TODO: Point this to a document on Cloud Storage
  final String imageUrl;

  /// An image representing the project.
  @JsonKey(includeFromJson: false, includeToJson: false)
  ImageProvider get image => AssetImage(imageUrl);

  /// The start date of the project
  final DateTime? startDate;

  /// The end date of the project. If null, the project is ongoing.
  final DateTime? endDate;

  @JsonKey(fromJson: _linksFromJson, toJson: _linksToJson)
  final List<ProjectLink> links;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

List<ProjectLink> _linksFromJson(List<Map<String, dynamic>> json) =>
    [for (final e in json) ProjectLink.fromJson(e)];

List<Map<String, dynamic>> _linksToJson(List<ProjectLink> links) =>
    [for (final link in links) link.toJson()];

@JsonSerializable()
class ProjectLink {
  /// A link to a project, such as a website or a repository.
  ProjectLink({
    required this.title,
    required this.imageUrl,
    required this.uri,
  });

  /// A title describing the link
  final String title;

  /// An url to the image representing the link
  /// TODO: Point this to a document on Cloud Storage
  final String imageUrl;

  /// An image representing the link
  @JsonKey(includeFromJson: false, includeToJson: false)
  ImageProvider get image => AssetImage(imageUrl);

  /// The URI that the link opens
  final Uri uri;

  factory ProjectLink.fromJson(Map<String, dynamic> json) =>
      _$ProjectLinkFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectLinkToJson(this);
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static final List<Project> projects = [
    Project(
      title: "Musician's Toolbox",
      description:
          "A mobile app that offers everything a musician needs for transcribing, practicing and performing.",
      imageUrl: "assets/projects/treble_clef.png",
      startDate: DateTime(2022),
      links: [
        ProjectLink(
          title: "Google Play",
          imageUrl: "assets/icons/google-play.png",
          uri: Uri.parse(
              "https://play.google.com/store/apps/details?id=se.agardh.musbx&pcampaignid=portfolio"),
        ),
        ProjectLink(
          title: "App Store",
          imageUrl: "assets/icons/app-store.png",
          uri: Uri.parse(
              "https://apps.apple.com/se/app/musicians-toolbox/id1670009655"),
        ),
      ],
    ),
    Project(
      title: "Dirma",
      description:
          "A website for the Swedish company Dirma, built using TypeScript and Next.js.",
      imageUrl: "assets/projects/dirma.png",
      startDate: DateTime(2023),
      endDate: DateTime(2023),
      links: [
        ProjectLink(
          title: "Website",
          imageUrl: "assets/icons/website.png",
          uri: Uri.parse("https://dirma.se"),
        ),
      ],
    ),
    Project(
      title: "Märklin Bluetooth controller",
      description:
          "A wireless hand controller for Märklin Sprint using Bluetooth LE.",
      imageUrl: "assets/projects/car.png",
      startDate: DateTime(2021),
      endDate: DateTime(2022),
      links: [
        ProjectLink(
          title: "GitHub",
          imageUrl: "assets/icons/github-mark.png",
          uri: Uri.parse("https://github.com/bemain/marklin_client"),
        ),
      ],
    ),
    Project(
      title: "Oxdjupet lajv",
      description:
          "A mobile app used during the larp I arrange yearly at Oxdjupet.",
      imageUrl: "assets/projects/oxdjupet.png",
      startDate: DateTime(2021),
      links: [
        ProjectLink(
          title: "Google Play",
          imageUrl: "assets/icons/google-play.png",
          uri: Uri.parse(
              "https://play.google.com/store/apps/details?id=se.agardh.lajv&pcampaignid=portfolio"),
        ),
        ProjectLink(
          title: "App Store",
          imageUrl: "assets/icons/app-store.png",
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
    switch (WindowSize.of(context)) {
      case WindowSize.compact:
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              launchUrl(project.links.first.uri);
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                height: 164,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Card.filled(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        child: Image(
                          image: project.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: _buildProjectText(context, project),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                for (ProjectLink link in project.links)
                                  _buildProjectLink(context, link),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      default:
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
                      child: _buildProjectLink(context, link),
                    ),
                ],
              ),
            ),
          ),
        );
    }
  }

  Widget _buildProjectLink(BuildContext context, ProjectLink link) {
    return Link(
      uri: link.uri,
      builder: (context, followLink) {
        return TextButton.icon(
          onPressed: followLink,
          icon: Image(
            image: link.image,
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          project.description,
          style: descriptionTextStyle(context),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
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
