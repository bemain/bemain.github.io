import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';

class Project {
  const Project({
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final ImageProvider image;
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key, required this.windowSize});

  final WindowSize windowSize;

  static const List<Project> projects = [
    Project(
      title: "Musician's Toolbox",
      description:
          "A mobile app that offers everything a musician needs for transcribing, practicing and performing.",
      image: NetworkImage("https://picsum.photos/1024/1024"),
    ),
    Project(
      title: "Project 2",
      description: "Description 2",
      image: NetworkImage("https://picsum.photos/1024/1024"),
    ),
    Project(
      title: "Project 3",
      description: "Description 3",
      image: NetworkImage("https://picsum.photos/1024/1024"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    switch (windowSize) {
      case WindowSize.compact:
        return Container(
          color: Theme.of(context).colorScheme.surfaceContainer,
          padding: windowSize.padding.add(
            EdgeInsets.only(top: windowSize.horizontalMargin),
          ),
          child: Column(
            children: [
              Text(
                "Projects",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              for (final Project project in projects)
                Card.filled(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.618,
                        child: Image(
                          image: project.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                        title: Text(project.title),
                        subtitle: Text(project.description),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      default:
        return Placeholder();
    }
  }
}
