import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/projects_section.dart';
import 'package:portfolio/title_section.dart';

class Frontpage extends StatelessWidget {
  Frontpage({super.key});

  final List<NavigationDrawerDestination> destinations = [
    NavigationDrawerDestination(
      icon: Icon(Icons.home),
      label: Text("Home"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.work),
      label: Text("Projects"),
    ),
  ];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize =
        WindowSize.fromSize(MediaQuery.sizeOf(context));

    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(context, windowSize),
      drawer: _buildDrawer(context, windowSize),
      body: ListView(
        children: [
          SizedBox(height: 48),
          SizedBox(
            height: MediaQuery.sizeOf(context).height -
                MediaQuery.paddingOf(context).top -
                kToolbarHeight -
                48 -
                MediaQuery.paddingOf(context).bottom,
            child: TitleSection(windowSize: windowSize),
          ),
          const Divider(),
          ProjectsSection(windowSize: windowSize),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WindowSize windowSize,
  ) {
    switch (windowSize) {
      case WindowSize.compact:
      case WindowSize.medium:
        return AppBar();

      default:
        return AppBar(
          title: Text("Benjamin Agardh"),
          actions: [
            for (final destination in destinations)
              TextButton.icon(
                onPressed: () {},
                label: destination.label,
                icon: destination.icon,
              ),
          ],
        );
    }
  }

  Widget? _buildDrawer(BuildContext context, WindowSize windowSize) {
    switch (windowSize) {
      case WindowSize.compact:
      case WindowSize.medium:
        return NavigationDrawer(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
            child: Text(
              "Benjamin Agardh",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...destinations,
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 16, 0),
            child: Text(
              """Engineering student with a passion for technology, music, and coding.""",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withAlpha(0xaa),
                  ),
            ),
          ),
          // TODO: Add "get in touch" button
        ]);

      default:
        return null;
    }
  }
}
