import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/projects_section.dart';
import 'package:portfolio/title_section.dart';

class Frontpage extends StatelessWidget {
  const Frontpage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.work_outline),
          selectedIcon: Icon(Icons.work),
          label: "Projects",
        ),
      ],
      smallBody: (context) {
        return ListView(
          children: [
            SizedBox(height: 48),
            TitleSection(windowSize: WindowSize.compact),
            ProjectsSection(windowSize: WindowSize.compact),
          ],
        );
      },
      body: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 102),
              TitleSection(windowSize: WindowSize.medium),
              ProjectsSection(windowSize: WindowSize.medium),
            ],
          ),
        );
      },
      mediumLargeBody: (context) {
        return ListView(
          children: [
            SizedBox(height: 48),
            TitleSection(windowSize: WindowSize.expanded),
            ProjectsSection(windowSize: WindowSize.expanded),
          ],
        );
      },
      largeBody: (context) {
        return ListView(
          children: [
            SizedBox(height: 48),
            TitleSection(windowSize: WindowSize.large),
            ProjectsSection(windowSize: WindowSize.large),
          ],
        );
      },
      extraLargeBody: (context) {
        return ListView(
          children: [
            SizedBox(height: 48),
            TitleSection(windowSize: WindowSize.extraLarge),
            ProjectsSection(windowSize: WindowSize.extraLarge),
          ],
        );
      },
    );
  }
}
