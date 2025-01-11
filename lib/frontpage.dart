import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:portfolio/layout.dart';
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
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              SizedBox(height: 48),
              TitleSection(windowSize: WindowSize.compact),
            ],
          ),
        );
      },
      body: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 102),
              TitleSection(windowSize: WindowSize.medium),
            ],
          ),
        );
      },
      mediumLargeBody: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              SizedBox(height: 48),
              TitleSection(windowSize: WindowSize.expanded),
            ],
          ),
        );
      },
      largeBody: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              SizedBox(height: 48),
              TitleSection(windowSize: WindowSize.large),
            ],
          ),
        );
      },
      extraLargeBody: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              SizedBox(height: 48),
              TitleSection(windowSize: WindowSize.extraLarge),
            ],
          ),
        );
      },
    );
  }
}
